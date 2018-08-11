require "db"

module Cassandra
  module DBApi
    class BindError < DB::Error
    end

    class ValueBinder
      def initialize(@cass_stmt : LibCass::CassStatement, @i : Int32)
      end

      def bind(value)
        # TODO: use error hander
        cass_error = do_bind(value)
        if cass_error != LibCass::CassError::Ok
          raise BindError.new(cass_error.to_s)
        end
      end

      private def do_bind(val : Nil)
        LibCass.statement_bind_null(@cass_stmt, @i)
      end

      private def do_bind(val : Bool)
        cass_value = val ? CassTrue : CassFalse
        LibCass.statement_bind_bool(@cass_stmt, @i, cass_value)
      end

      private def do_bind(val : Float32)
        LibCass.statement_bind_float(@cass_stmt, @i, val)
      end

      private def do_bind(val : Float64)
        LibCass.statement_bind_double(@cass_stmt, @i, val)
      end

      private def do_bind(val : Int8)
        LibCass.statement_bind_int8(@cass_stmt, @i, val)
      end

      private def do_bind(val : Int16)
        LibCass.statement_bind_int16(@cass_stmt, @i, val)
      end

      private def do_bind(val : Int32)
        LibCass.statement_bind_int32(@cass_stmt, @i, val)
      end

      private def do_bind(val : Int64)
        LibCass.statement_bind_int64(@cass_stmt, @i, val)
      end

      private def do_bind(val : Bytes)
        # LibCass.statement_bind_bytes(@cass_stmt, @i, val, val.size)
        raise NotImplementedError.new("Test first")
      end

      private def do_bind(val : String)
        LibCass.statement_bind_string_n(@cass_stmt, @i, val, val.bytesize)
      end

      private def do_bind(val : DBApi::Duration)
        LibCass.statement_bind_duration(@cass_stmt,
                                        @i,
                                        val.months,
                                        val.days,
                                        val.nanoseconds)
      end

      private def do_bind(val : DBApi::Date)
        LibCass.statement_bind_uint32(@cass_stmt, @i, val.days)
      end

      private def do_bind(val : DBApi::Time)
        LibCass.statement_bind_int64(@cass_stmt, @i, val.total_nanoseconds)
      end

      private def do_bind(val : ::Time)
        ms = (val - EPOCH_START).total_milliseconds.to_i64
        LibCass.statement_bind_int64(@cass_stmt, @i, ms)
      end

      private def do_bind(val : DBApi::Uuid | DBApi::TimeUuid)
        LibCass.statement_bind_uuid(@cass_stmt, @i, val)
      end

      private def do_bind(vals : Array(Primitive))
        cass_collection = LibCass.collection_new(
          LibCass::CassCollectionType::CollectionTypeList,
          vals.size
        )
        begin
          vals.each { |val| append(cass_collection, val) }
          LibCass.statement_bind_collection(@cass_stmt, @i, cass_collection)
        ensure
          LibCass.collection_free(cass_collection)
        end
      end

      private def do_bind(vals : Set(Primitive))
        cass_collection = LibCass.collection_new(
          LibCass::CassCollectionType::CollectionTypeSet,
          vals.size
        )
        begin
          vals.each { |val| append(cass_collection, val) }
          LibCass.statement_bind_collection(@cass_stmt, @i, cass_collection)
        ensure
          LibCass.collection_free(cass_collection)
        end
      end

      private def do_bind(vals : Hash(Primitive, Primitive))
        cass_map = LibCass.collection_new(
          LibCass::CassCollectionType::CollectionTypeMap,
          vals.size
        )
        begin
          vals.each { |entry| entry.each { |v| append(cass_map, v) } }
          LibCass.statement_bind_collection(@cass_stmt, @i, cass_map)
        ensure
          LibCass.collection_free(cass_map)
        end
      end

      private def append(cass_coll : LibCass::CassCollection, val : Int8)
        LibCass.collection_append_int8(cass_coll, val)
      end

      private def append(cass_coll : LibCass::CassCollection, val : Int16)
        LibCass.collection_append_int16(cass_coll, val)
      end

      private def append(cass_coll : LibCass::CassCollection, val : Int32)
        LibCass.collection_append_int32(cass_coll, val)
      end

      private def append(cass_coll : LibCass::CassCollection, val : Int64)
        LibCass.collection_append_int64(cass_coll, val)
      end

      private def append(cass_coll : LibCass::CassCollection, val : Float32)
        LibCass.collection_append_float(cass_coll, val)
      end

      private def append(cass_coll : LibCass::CassCollection, val : Float64)
        LibCass.collection_append_double(cass_coll, val)
      end

      private def append(cass_coll : LibCass::CassCollection, val : String)
        LibCass.collection_append_string_n(cass_coll, val, val.size)
      end
    end
  end
end
