require "db"
require "../libcass"
require "./session"
require "./binder"

module Cassandra
  module DBApi
    class StatementError < DB::Error
    end

    class RawStatement < DB::Statement
      @cass_result_future : LibCass::CassFuture?
      @cass_statement : LibCass::CassStatement
      @session : Cassandra::DBApi::Session

      def initialize(session, cql : String, paging_size)
        initialize(session, create_statement(cql), cql, paging_size)
      end

      def initialize(@session, @cass_statement, cql : String, paging_size : UInt64?)
        super(@session, cql)
        if paging_size
          LibCass.statement_set_paging_size(@cass_statement, paging_size)
        end
      end

      def do_close
        LibCass.statement_free(@cass_statement)
        super
      end

      def to_unsafe
        @cass_statement
      end

      def reset_paging_state
        LibCass.statement_set_paging_state_token(@cass_statement, "", 0)
      end

      protected def create_statement(cql)
        LibCass.statement_new(cql, 0)
      end

      protected def perform_query(args : Enumerable) : ResultSet
        rebind_params(args)
        ResultSet.new(@session, self)
      end

      protected def perform_exec(args : Enumerable) : DB::ExecResult
        rebind_params(args)
        cass_result_future = LibCass.session_execute(@session, @cass_statement)
        begin
          Error.from_future(cass_result_future, StatementError)
        ensure
          LibCass.future_free(cass_result_future)
        end

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

      class StatementPrepareError < DB::Error
      end

      def initialize(@session : DBApi::Session,
                     cql : String,
                     paging_size : UInt64?)
        super(@session, cql)
        @cass_prepared = prepare(@session, cql)
        cass_statement = create_statement(@cass_prepared)
        @statement = RawStatement.new(@session, cass_statement, cql, paging_size)
      end

      def do_close
        @statement.do_close
        LibCass.prepared_free(@cass_prepared)
        super
      end

      protected def prepare(session, cql)
        cass_prepare_future = LibCass.session_prepare(session, cql)
        begin
          Error.from_future(cass_prepare_future, StatementPrepareError)
          LibCass.future_get_prepared(cass_prepare_future)
        ensure
          LibCass.future_free(cass_prepare_future)
        end
      end

      protected def create_statement(cass_prepared : LibCass::CassPrepared)
        LibCass.prepared_bind(cass_prepared)
      end

      def perform_query(*args, **options) : DB::ResultSet
        @statement.perform_query(*args, **options)
      end

      def perform_exec(*args, **options) : DB::ExecResult
        @statement.perform_exec(*args, **options)
      end
    end
  end
end
