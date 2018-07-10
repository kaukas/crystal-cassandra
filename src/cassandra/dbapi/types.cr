require "db"
require "../libcass"

module Cassandra
  module DBApi
    EPOCH_START = ::Time.epoch(0)
    CassTrue = LibCass::BoolT::True
    CassFalse = LibCass::BoolT::False

    class BindError < DB::Error
    end

    class UUID
      def initialize(@cass_uuid : LibCass::CassUuid)
      end
      # TODO: display (.to_s)
    end

    class Date
      getter date

      def initialize(@date : ::Time)
      end

      def initialize(days : UInt32)
        @date = EPOCH_START + ::Time::Span.new(days, 0, 0, 0)
      end

      def days : UInt32
        (@date - EPOCH_START).days.to_u32
      end

      def ==(other : self) : Bool
        @date == other.date
      end

      def to_s
        @date.to_s
      end
    end

    class Time
      getter time

      def initialize(@time : ::Time)
      end

      def initialize(nanoseconds : Int64)
        @time = EPOCH_START + ::Time::Span.new(nanoseconds: nanoseconds)
      end

      def total_nanoseconds : Int64
        (@time - @time.date).total_nanoseconds.to_i64
      end

      def ==(other : self) : Bool
        @time == other.time
      end

      def to_s
        @time.to_s
      end
    end

    abstract class BaseDecoder
      @@types_by_code = Hash(LibCass::CassValueType, BaseDecoder).new

      def decode(cass_value : LibCass::CassValue)
        if LibCass.value_is_null(cass_value) == CassTrue
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
        handle_error(LibCass.value_get_string(cass_value, out s, out len))
        String.new(s, len)
      end
    end

    class TinyIntDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeTinyInt]
      end

      def decode_with_type(cass_value) : Int8
        handle_error(LibCass.value_get_int8(cass_value, out i))
        i.to_i8
      end
    end

    class SmallIntDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeSmallInt]
      end

      def decode_with_type(cass_value) : Int16
        handle_error(LibCass.value_get_int16(cass_value, out i))
        i
      end
    end

    class IntDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeInt]
      end

      def decode_with_type(cass_value) : Int32
        handle_error(LibCass.value_get_int32(cass_value, out i))
        i
      end
    end

    class BigintDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeBigint]
      end

      def decode_with_type(cass_value) : Int64
        handle_error(LibCass.value_get_int64(cass_value, out i))
        i
      end
    end

    class FloatDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeFloat]
      end

      def decode_with_type(cass_value) : Float32
        handle_error(LibCass.value_get_float(cass_value, out f))
        f
      end
    end

    class DoubleDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeDouble]
      end

      def decode_with_type(cass_value) : Float64
        handle_error(LibCass.value_get_double(cass_value, out f))
        f
      end
    end

    class DateDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeDate]
      end

      def decode_with_type(cass_value) : Date
        handle_error(LibCass.value_get_uint32(cass_value, out days))
        Date.new(days)
      end
    end

    class TimeDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeTime]
      end

      def decode_with_type(cass_value) : DBApi::Time
        handle_error(LibCass.value_get_int64(cass_value, out nanoseconds))
        Time.new(nanoseconds)
      end
    end

    class TimestampDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeTimestamp]
      end

      def decode_with_type(cass_value) : ::Time
        handle_error(LibCass.value_get_int64(cass_value, out milliseconds))
        ::Time.epoch_ms(milliseconds)
      end
    end

    class TimeuuidDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::CassValueTypeTimeuuid]
      end

      def decode_with_type(cass_value) : UUID
        handle_error(LibCass.value_get_uuid(cass_value, out cass_uuid))
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
        LibCass.statement_bind_null(@cass_stmt, @i)
      end

      private def do_bind(val : Bool)
        # cass_value = val ? CassTrue : CassFalse
        # LibCass.statement_bind_bool(@cass_stmt, @i, cass_value)
        raise NotImplementedError.new("Test first")
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
    end
  end
end
