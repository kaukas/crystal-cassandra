require "db"
require "../libcass"
require "./connection"

module Cassandra
  module DBApi
    class StatementError < DB::Error
    end

    class Statement < DB::Statement
      @cass_result_future : LibCass::CassFuture | Nil
      @session : Cassandra::DBApi::Session

      def initialize(connection : DBApi::Connection, @sql : String)
        super(connection)
        @session = connection.session
        # TODO: parameter count can be more than 0.
        @cass_statement = LibCass.statement_new(@sql, 0)
      end

      def do_close
        LibCass.statement_free(@cass_statement)
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
        # Result.new(cass_result_future)
        LibCass.future_free(cass_result_future)

        # TODO: affected rows, last_insert_id
        DB::ExecResult.new(0, 0)
      end

      private def rebind_params(args : Enumerable)
        LibCass.statement_reset_parameters(@cass_statement, args.size)
        args.each_with_index do |arg, i|
          ValueBinder.new(@cass_statement, i).bind(arg)
        end
      end
    end
  end
end
