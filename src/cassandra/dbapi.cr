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
    alias Primitive = DB::Any | Int8 | Int16 | DBApi::Date | DBApi::Time |
      DBApi::Duration | DBApi::Uuid | DBApi::TimeUuid
    alias Collection = Array(Primitive) | Set(Primitive) |
      Hash(Primitive, Primitive)
    alias Any = Primitive | Collection

    class Driver < DB::Driver
      def build_connection(context : DB::ConnectionContext)
        DBApi::Connection.new(context)
      end
    end
  end
end

DB.register_driver "cassandra", Cassandra::DBApi::Driver
