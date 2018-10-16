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
    alias Primitive = DB::Any | Int8 | Int16 | DBApi::Date | DBApi::Duration |
      DBApi::Time | DBApi::Uuid | DBApi::TimeUuid
    struct Any
      @value : Primitive | Array(Any) | Set(Any) | Hash(Any, Any)

      property value

      def initialize(@value)
      end

      def ==(other : Any)
        @value == other.value
      end

      def ==(other)
        @value == other
      end

      # TODO: test us.
      def as_s
        @value.as(String)
      end

      def as_i
        @value.as(Int32)
      end
    end

    class Driver < DB::Driver
      def build_connection(context : DB::ConnectionContext)
        DBApi::Connection.new(context)
      end
    end
  end
end

DB.register_driver "cassandra", Cassandra::DBApi::Driver
