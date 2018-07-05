require "db"
require "../libcass"

module Cassandra
  module DBApi
    CassTrue = LibCass::CassBoolT::CassTrue
    CassFalse = LibCass::CassBoolT::CassFalse

    class BindError < DB::Error
    end

    abstract class BaseType
      @@types_by_code = Hash(LibCass::CassValueType, BaseType).new

      abstract def from_db(cass_value : LibCass::CassValue)

      def self.cass_value_codes : Array(LibCass::CassValueType)
        raise NotImplementedError.new
      end

      macro inherited
        BaseType.register_type({{@type}})
      end

      def self.register_type(type_class : BaseType.class)
        instance = type_class.new
        type_class.cass_value_codes.each do |cass_value_code|
          @@types_by_code[cass_value_code] = instance
        end
      end

      # TODO: pick the type converters once and reuse.
      def self.from_db(cass_value : LibCass::CassValue)
        if LibCass.cass_value_is_null(cass_value) == CassTrue
          return nil
        end
        detect_db_type(cass_value).from_db(cass_value)
      end

      private def self.detect_db_type(cass_value : LibCass::CassValue)
        type_code = LibCass.cass_value_type(cass_value)
        @@types_by_code[type_code]
      end
    end

    class StringType < BaseType
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeAscii,
         LibCass::CassValueType::CassValueTypeVarchar]
      end

      def from_db(cass_value) : String
        LibCass.cass_value_get_string(cass_value, out s, out len)
        String.new(s, len)
      end
    end

    class IntType < BaseType
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeInt]
      end

      def from_db(cass_value) : Int32
        LibCass.cass_value_get_int32(cass_value, out i)
        i
      end
    end

    class BigintType < BaseType
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeBigint]
      end

      def from_db(cass_value) : Int64
        LibCass.cass_value_get_int64(cass_value, out i)
        i
      end
    end


    class ValueBinder
      def initialize(@cass_stmt : LibCass::CassStatement, @i : Int32)
      end

      def bind(value)
        cass_error = do_bind(value)
        if cass_error != LibCass::CassError::CassOk
          raise BindError.new(cass_error.to_s)
        end
      end

      private def do_bind(val : Nil)
        LibCass.cass_statement_bind_null(@cass_stmt, @i)
      end

      private def do_bind(val : Bool)
        # cass_value = val ? CassTrue : CassFalse
        # LibCass.cass_statement_bind_bool(@cass_stmt, @i, cass_value)
        raise NotImplementedError.new("Test first")
      end

      private def do_bind(val : Float32)
        # LibCass.cass_statement_bind_float(@cass_stmt, @i, val)
        raise NotImplementedError.new("Test first")
      end

      private def do_bind(val : Float64)
        # LibCass.cass_statement_bind_double(@cass_stmt, @i, val)
        raise NotImplementedError.new("Test first")
      end

      private def do_bind(val : Int32)
        LibCass.cass_statement_bind_int32(@cass_stmt, @i, val)
      end

      private def do_bind(val : Int64)
        LibCass.cass_statement_bind_int64(@cass_stmt, @i, val)
      end

      private def do_bind(val : Bytes)
        # LibCass.cass_statement_bind_bytes(@cass_stmt, @i, val, val.size)
        raise NotImplementedError.new("Test first")
      end

      private def do_bind(val : String)
        LibCass.cass_statement_bind_string_n(@cass_stmt, @i, val, val.bytesize)
      end

      private def do_bind(val : Time)
        # epoch_ms = val.epoch_ms
        # LibCass.cass_statement_bind_int64(@cass_stmt, @i, epoch_ms)
        raise NotImplementedError.new("Test first")
      end
    end
  end
end
