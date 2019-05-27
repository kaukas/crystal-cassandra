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
    class Driver < DB::Driver
      # Builds a Cassandra connection for the given `DB::ConnectionContext`.
      def build_connection(context : DB::ConnectionContext)
        DBApi::Connection.acquire(context)
      end
    end

    # These types that can be supplied to queries as bound parameters without
    # wrapping them with `Cassandra::DBApi::Any`. Example:
    #
    # ```crystal
    # db.exec("insert into posts (id, title) values (?, ?)", 1, "A Post")
    # ```
    #
    # They are also returned as query results:
    #
    # ```crystal
    # db.query("select id, title from posts") do |rs|
    #   rs.each do
    #     puts rs.read(Int32), rs.read(String)
    #   end
    # end
    # ```
    alias Primitive = DB::Any | Int8 | Int16 | DBApi::Date | DBApi::Time |
      DBApi::Uuid | DBApi::TimeUuid

    # All supported Cassandra types.
    #
    # Items of collections are wrapped with `Cassandra::DBApi::Any`. A query
    # parameter example:
    #
    # ```crystal
    # db.exec("insert into posts (id, authors) values (?, ?)",
    #         1,
    #         Any.new([Any.new("A Post")]))
    # ```
    #
    # A query result example:
    #
    # ```crystal
    # db.query("select id, authors from posts") do |rs|
    #   rs.each do
    #     puts rs.read(Int32), rs.read(Array(Any)).map(&.as_s)
    #   end
    # end
    # ```
    alias Type = Primitive | Array(Any) | Set(Any) | Hash(Any, Any)

    # Wraps any possible Cassandra value. It can be supplied as a parameter for
    # a query or be returned as a result. It dynamically handles values with
    # actual types decided at runtime.
    #
    # `Cassandra::DBApi::Any` serves a similar purpose as
    # [`JSON::Any`](https://crystal-lang.org/api/latest/JSON/Any.html).
    #
    # In order to obtain the actual value use the `as_*` methods which perform
    # type checks against the raw underlying value.
    struct Any
      # Returns the raw underlying value.
      getter raw : Type

      # Creates a `Cassandra::DBApi::Any` that wraps the given value.
      def initialize(@raw : Type)
      end

      # Compares this `Any` to the given `Any` by comparing their values.
      def ==(other : Any)
        @raw == other.raw
      end

      # Compares the raw value to the given value.
      def ==(other)
        @raw == other
      end

      # Checks that the underlying value is `Nil`, and returns `nil`.
      # Raises otherwise.
      def as_nil
        @raw.as(Nil)
      end

      private macro def_for_type(as_method, type)
        # Checks that the underlying value is `{{ type }}`, and returns its value.
        # Raises otherwise.
        def {{ as_method }} : {{ type }}
          @raw.as({{ type }})
        end

        # Checks that the underlying value is `{{ type }}`, and returns its value.
        # Returns `nil` otherwise.
        def {{ as_method }}? : {{ type }}?
          {{ as_method }} if @raw.is_a?({{ type }})
        end
      end

      def_for_type(as_bool, Bool)
      def_for_type(as_i8, Int8)
      def_for_type(as_i16, Int16)
      def_for_type(as_i32, Int32)
      def_for_type(as_i64, Int64)
      def_for_type(as_f32, Float32)
      def_for_type(as_f64, Float64)
      def_for_type(as_s, String)
      def_for_type(as_bytes, Bytes)
      def_for_type(as_timestamp, ::Time)
      def_for_type(as_date, DBApi::Date)
      def_for_type(as_time, DBApi::Time)
      def_for_type(as_uuid, DBApi::Uuid)
      def_for_type(as_timeuuid, DBApi::TimeUuid)
      def_for_type(as_a, Array(Any))
      def_for_type(as_set, Set(Any))
      def_for_type(as_h, Hash(Any, Any))
    end
  end
end

DB.register_driver "cassandra", Cassandra::DBApi::Driver
