require "db"
require "../libcass"
require "./connection"
require "./binder"

module Cassandra
  module DBApi
    class StatementError < DB::Error
    end

    class RawStatement < DB::Statement
      @cass_result_future : LibCass::CassFuture | Nil
      @cass_statement : LibCass::CassStatement
      @session : Cassandra::DBApi::Session

      def initialize(connection : DBApi::Connection, cql : String)
        initialize(connection, create_statement(cql))
      end

      def initialize(connection : DBApi::Connection, @cass_statement)
        super(connection)
        @session = connection.session
      end

      def do_close
        LibCass.statement_free(@cass_statement)
      end

      protected def create_statement(cql : String)
        LibCass.statement_new(cql, 0)
      end

      protected def perform_query(args : Enumerable) : ResultSet
        rebind_params(args)
        cass_result_future = LibCass.session_execute(@session, @cass_statement)
        Error.from_future(cass_result_future, StatementError)
        ResultSet.new(self, cass_result_future)
      end

      protected def perform_exec(args : Enumerable) : DB::ExecResult
        rebind_params(args)
        cass_result_future = LibCass.session_execute(@session, @cass_statement)
        Error.from_future(cass_result_future, StatementError)
        LibCass.future_free(cass_result_future)

        # Cassandra does not support affected rows nor last_insert_id.
        DB::ExecResult.new(0, 0)
      end

      protected def rebind_params(args : Enumerable)
        LibCass.statement_reset_parameters(@cass_statement, args.size)
        args.each_with_index do |arg, i|
          ValueBinder.new(@cass_statement, i).bind(arg)
        end
      end
    end

    class PreparedStatement < DB::Statement
      @cass_prepared : LibCass::CassPrepared
      @statement : RawStatement

      delegate perform_query, perform_exec, to: @statement

      class StatementPrepareError < DB::Error
      end

      def initialize(connection : DBApi::Connection, cql : String)
        super(connection)
        @cass_prepared = prepare(connection.session, cql)
        cass_statement = create_statement(@cass_prepared)
        @statement = RawStatement.new(connection, cass_statement)
      end

      def do_close
        @statement.do_close
        LibCass.prepared_free(@cass_prepared)
      end

      protected def prepare(session, cql)
        cass_prepare_future = LibCass.session_prepare(session, cql)
        Error.from_future(cass_prepare_future, StatementPrepareError)
        cass_prepared = LibCass.future_get_prepared(cass_prepare_future)
        LibCass.future_free(cass_prepare_future)
        cass_prepared
      end

      protected def create_statement(cass_prepared : LibCass::CassPrepared)
        LibCass.prepared_bind(cass_prepared)
      end
    end
  end
end
