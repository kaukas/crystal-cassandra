require "db"
require "../libcass"

module Cassandra
  module DBApi
    CassTrue = LibCass::CassBoolT::CassTrue
    CassFalse = LibCass::CassBoolT::CassFalse

    class BindError < DB::Error
    end

    class UUID
      def initialize(@cass_uuid : LibCass::CassUuid)
      end
      # TODO: display (.to_s)
    end

    abstract class BaseDecoder
      @@types_by_code = Hash(LibCass::CassValueType, BaseDecoder).new

      def decode(cass_value : LibCass::CassValue)
        if LibCass.cass_value_is_null(cass_value) == CassTrue
          return nil
        else
          decode_with_type(cass_value)
        end
      end

      def handle_error(cass_error : LibCass::CassError)
        Error.from_error(cass_error)
      end

      abstract def decode_with_type(cass_value : LibCass::CassValue)

      def self.cass_value_codes : Array(LibCass::CassValueType)
        raise NotImplementedError.new
      end

      macro inherited
        BaseDecoder.register_type({{@type}})
      end

      def self.register_type(type_class : BaseDecoder.class)
        instance = type_class.new
        type_class.cass_value_codes.each do |cass_value_code|
          @@types_by_code[cass_value_code] = instance
        end
      end

      def self.get_decoder(cass_value_type : LibCass::CassValueType)
        @@types_by_code[cass_value_type]
      end
    end

    class StringDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeAscii,
         LibCass::CassValueType::CassValueTypeVarchar]
      end

      def decode_with_type(cass_value) : String
        handle_error(LibCass.cass_value_get_string(cass_value, out s, out len))
        String.new(s, len)
      end
    end

    class IntDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeInt]
      end

      def decode_with_type(cass_value) : Int32
        handle_error(LibCass.cass_value_get_int32(cass_value, out i))
        i
      end
    end

    class BigintDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeBigint]
      end

      def decode_with_type(cass_value) : Int64
        handle_error(LibCass.cass_value_get_int64(cass_value, out i))
        i
      end
    end

    class TimeuuidDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeTimeuuid]
      end

      def decode_with_type(cass_value) : UUID
        handle_error(LibCass.cass_value_get_uuid(cass_value, out cass_uuid))
        UUID.new(cass_uuid)
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
