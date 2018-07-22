require "db"
require "./libcass"
require "./dbapi/types"
require "./dbapi/error_handler"
require "./dbapi/result_set"
require "./dbapi/session"
require "./dbapi/statement"
require "./dbapi/connection"

module Cassandra
  module DBApi
    alias Any = DB::Any | Int8 | Int16 | DBApi::Date | DBApi::Time |
                DBApi::Duration | DBApi::Uuid | DBApi::TimeUuid

    class Driver < DB::Driver
      def build_connection(context : DB::ConnectionContext)
        DBApi::Connection.new(context)
      end
    end
  end
end

DB.register_driver "cassandra", Cassandra::DBApi::Driver
