require "db"

module Cassandra
  module DBApi
    class ValueBinder
      class BindError < DB::Error
      end

      def initialize(@cass_stmt : LibCass::CassStatement, @i : Int32); end

      def bind(any)
        param_count, _setter = do_bind(any)
        {param_count, ->do
          cass_error = _setter.call
          if cass_error != LibCass::CassError::Ok
            val_s = any.inspect
            val_s = "#{val_s[0..1000]}…" if val_s.size > 1500
            raise BindError.new("#{cass_error}: passed\n#{val_s}\n" \
                                "of type #{typeof(any)} at index #{@i}")
          end
        end}
      end

      private def do_bind(consistency : Consistency)
        {0, ->do
          LibCass.statement_set_consistency(@cass_stmt,
            Cassandra::LibCass::CassConsistency.new(consistency.value))
        end}
      end

      private def do_bind(consistency : SerialConsistency)
        {0, ->do
          LibCass.statement_set_serial_consistency(@cass_stmt,
            Cassandra::LibCass::CassConsistency.new(consistency.value))
        end}
      end

      private def do_bind(timeout : RequestTimeout)
        {0, ->do
          LibCass.statement_set_request_timeout(@cass_stmt, timeout.timeout_ms)
        end}
      end

      private def do_bind(idempotent : Idempotent)
        cass_value = idempotent.idempotent ? LibCass::BoolT::True : LibCass::BoolT::False
        {0, ->{ LibCass.statement_set_is_idempotent(@cass_stmt, cass_value) }}
      end

      private def do_bind(val : Any)
        do_bind(val.raw)
      end

      private def do_bind(val : Nil)
        {1, ->{ LibCass.statement_bind_null(@cass_stmt, @i) }}
      end

      private def do_bind(val : Bool)
        cass_value = val ? LibCass::BoolT::True : LibCass::BoolT::False
        {1, ->{ LibCass.statement_bind_bool(@cass_stmt, @i, cass_value) }}
      end

      private def do_bind(val : Float32)
        {1, ->{ LibCass.statement_bind_float(@cass_stmt, @i, val) }}
      end

      private def do_bind(val : Float64)
        {1, ->{ LibCass.statement_bind_double(@cass_stmt, @i, val) }}
      end

      private def do_bind(val : Int8)
        {1, ->{ LibCass.statement_bind_int8(@cass_stmt, @i, val) }}
      end

      private def do_bind(val : Int16)
        {1, ->{ LibCass.statement_bind_int16(@cass_stmt, @i, val) }}
      end

      private def do_bind(val : Int32)
        {1, ->{ LibCass.statement_bind_int32(@cass_stmt, @i, val) }}
      end

      private def do_bind(val : Int64)
        {1, ->{ LibCass.statement_bind_int64(@cass_stmt, @i, val) }}
      end

      private def do_bind(val : Bytes)
        {1, ->{ LibCass.statement_bind_bytes(@cass_stmt, @i, val, val.size) }}
      end

      private def do_bind(val : String)
        {1, ->{ LibCass.statement_bind_string_n(@cass_stmt, @i, val, val.bytesize) }}
      end

      private def do_bind(val : DBApi::Date)
        {1, ->{ LibCass.statement_bind_uint32(@cass_stmt, @i, val.days) }}
      end

      private def do_bind(val : DBApi::Time)
        {1, ->{ LibCass.statement_bind_int64(@cass_stmt, @i, val.total_nanoseconds) }}
      end

      private def do_bind(val : ::Time)
        ms = (val - EPOCH_START).total_milliseconds.to_i64
        {1, ->{ LibCass.statement_bind_int64(@cass_stmt, @i, ms) }}
      end

      private def do_bind(val : DBApi::Uuid | DBApi::TimeUuid)
        {1, ->{ LibCass.statement_bind_uuid(@cass_stmt, @i, val) }}
      end

      private def do_bind(vals : Array)
        {1, ->do
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
        end}
      end

      private def do_bind(vals : Set)
        {1, ->do
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
        end}
      end

      private def do_bind(vals : Hash(Any, Any))
        {1, ->do
          cass_map = LibCass.collection_new(
            LibCass::CassCollectionType::CollectionTypeMap,
            vals.size
          )
          begin
            vals.each { |entry| entry.each { |v| append(cass_map, v.raw) } }
            LibCass.statement_bind_collection(@cass_stmt, @i, cass_map)
          ensure
            LibCass.collection_free(cass_map)
          end
        end}
      end

      private def append(cass_coll : LibCass::CassCollection, val : Nil)
        raise BindError.new("Cassandra does not support NULLs in collections")
      end

      private def append(cass_coll : LibCass::CassCollection, val : Bool)
        cass_value = val ? LibCass::BoolT::True : LibCass::BoolT::False
        LibCass.collection_append_bool(cass_coll, cass_value)
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

      private def append(cass_coll : LibCass::CassCollection, val : Bytes)
        # LibCass.statement_bind_bytes(@cass_stmt, @i, val, val.size)
        raise NotImplementedError.new("Test first")
      end

      private def append(cass_coll : LibCass::CassCollection, val : String)
        LibCass.collection_append_string_n(cass_coll, val, val.size)
      end

      private def append(cass_coll : LibCass::CassCollection, val : DBApi::Date)
        LibCass.collection_append_uint32(cass_coll, val.days)
      end

      private def append(cass_coll : LibCass::CassCollection, val : ::Time)
        ms = (val - EPOCH_START).total_milliseconds.to_i64
        LibCass.collection_append_int64(cass_coll, ms)
      end

      private def append(cass_coll : LibCass::CassCollection, val : DBApi::Time)
        LibCass.collection_append_int64(cass_coll, val.total_nanoseconds)
      end

      private def append(cass_coll : LibCass::CassCollection,
                         val : DBApi::Uuid | DBApi::TimeUuid)
        LibCass.collection_append_uuid(cass_coll, val)
      end

      private def append(cass_coll : LibCass::CassCollection, vals : Array)
        cass_list = LibCass.collection_new(
          LibCass::CassCollectionType::CollectionTypeList,
          vals.size
        )
        begin
          vals.each { |item| append(cass_list, item) }
          LibCass.collection_append_collection(cass_coll, cass_list)
        ensure
          LibCass.collection_free(cass_list)
        end
      end

      private def append(cass_coll : LibCass::CassCollection, vals : Set)
        cass_set = LibCass.collection_new(
          LibCass::CassCollectionType::CollectionTypeSet,
          vals.size
        )
        begin
          vals.each { |item| append(cass_set, item) }
          LibCass.collection_append_collection(cass_coll, cass_set)
        ensure
          LibCass.collection_free(cass_set)
        end
      end

      private def append(cass_coll : LibCass::CassCollection,
                         vals : Hash(Any, Any))
        cass_map = LibCass.collection_new(
          LibCass::CassCollectionType::CollectionTypeMap,
          vals.size
        )
        begin
          vals.each { |entry| entry.each { |v| append(cass_map, v.raw) } }
          LibCass.collection_append_collection(cass_coll, cass_map)
        ensure
          LibCass.collection_free(cass_map)
        end
      end

      private def append(cass_coll : LibCass::CassCollection, any : Any)
        append(cass_coll, any.raw)
      end
    end
  end
end
