require "db"
require "../libcass"

module Cassandra
  module DBApi
    EPOCH_START = ::Time.epoch(0)
    CassTrue = LibCass::BoolT::True
    CassFalse = LibCass::BoolT::False

    class BindError < DB::Error
    end

    class UuidError < DB::Error
    end

    module CommonUuid
      @cass_uuid : LibCass::CassUuid

      def initialize(s : String)
        @cass_uuid = from_string(s)
      end

      def initialize(@cass_uuid)
      end

      private def from_string(s : String)
        Error.from_error(LibCass.uuid_from_string_n(s, s.size, out cass_uuid),
                         UuidError)
        cass_uuid
      end

      def to_unsafe
        @cass_uuid
      end

      def to_s
        # Strings are immutable. Create an array of C chars instead.
        output = Array(LibC::Char).new(LibCass::UUID_STRING_LENGTH, 0).to_unsafe
        LibCass.uuid_string(@cass_uuid, output)
        # Omit the final \0 char.
        String.new(output, LibCass::UUID_STRING_LENGTH - 1)
      end
    end

    struct Uuid
      include CommonUuid
    end

    struct TimeUuid
      include CommonUuid

      def to_time : ::Time
        milliseconds = LibCass.uuid_timestamp(@cass_uuid)
        EPOCH_START + ::Time::Span.new(nanoseconds: milliseconds * 1_000_000)
      end
    end

    struct Date
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

    struct Time
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

    struct Duration
      getter months
      getter days
      getter nanoseconds

      def initialize(@months : Int32 = 0,
                     @days : Int32 = 0,
                     @nanoseconds : Int64 = 0)
      end

      def initialize(@months : Int32 = 0,
                     @days : Int32 = 0,
                     time_span : ::Time::Span = Time::Span.zero)
        @nanoseconds = time_span.total_nanoseconds.to_i64
      end

      def ==(other : self) : Bool
        @months == other.months &&
          @days == other.days &&
          @nanoseconds == other.nanoseconds
      end

      def time_span : ::Time::Span
        ::Time::Span.new(nanoseconds: @nanoseconds)
      end

      def to_s
        span = ::Time::Span.new(nanoseconds: @nanoseconds)
        sprintf("P0000-%02d-%02dT%02d:%02d:%02d",
                @months,
                @days,
                span.hours,
                span.minutes,
                span.seconds)
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

      protected def self.cass_value_codes : Array(LibCass::CassValueType)
        raise NotImplementedError.new
      end

      protected def self.auto_register? : Bool
        true
      end

      macro inherited
        BaseDecoder.register_type({{@type}}) if {{@type}}.auto_register?
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
        [LibCass::CassValueType::ValueTypeAscii,
         LibCass::CassValueType::ValueTypeVarchar]
      end

      def decode_with_type(cass_value) : String
        handle_error(LibCass.value_get_string(cass_value, out s, out len))
        String.new(s, len)
      end
    end

    class TinyIntDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeTinyInt]
      end

      def decode_with_type(cass_value) : Int8
        handle_error(LibCass.value_get_int8(cass_value, out i))
        i.to_i8
      end
    end

    class SmallIntDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeSmallInt]
      end

      def decode_with_type(cass_value) : Int16
        handle_error(LibCass.value_get_int16(cass_value, out i))
        i
      end
    end

    class IntDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeInt]
      end

      def decode_with_type(cass_value) : Int32
        handle_error(LibCass.value_get_int32(cass_value, out i))
        i
      end
    end

    class BigintDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeBigint]
      end

      def decode_with_type(cass_value) : Int64
        handle_error(LibCass.value_get_int64(cass_value, out i))
        i
      end
    end

    class FloatDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeFloat]
      end

      def decode_with_type(cass_value) : Float32
        handle_error(LibCass.value_get_float(cass_value, out f))
        f
      end
    end

    class DoubleDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeDouble]
      end

      def decode_with_type(cass_value) : Float64
        handle_error(LibCass.value_get_double(cass_value, out f))
        f
      end
    end

    class DurationDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeDuration]
      end

      def decode_with_type(cass_value) : DBApi::Duration
        handle_error(LibCass.value_get_duration(cass_value,
                                                out months,
                                                out days,
                                                out nanoseconds))
        DBApi::Duration.new(months, days, nanoseconds)
      end
    end

    class DateDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeDate]
      end

      def decode_with_type(cass_value) : Date
        handle_error(LibCass.value_get_uint32(cass_value, out days))
        Date.new(days)
      end
    end

    class TimeDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeTime]
      end

      def decode_with_type(cass_value) : DBApi::Time
        handle_error(LibCass.value_get_int64(cass_value, out nanoseconds))
        Time.new(nanoseconds)
      end
    end

    class TimestampDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeTimestamp]
      end

      def decode_with_type(cass_value) : ::Time
        handle_error(LibCass.value_get_int64(cass_value, out milliseconds))
        ::Time.epoch_ms(milliseconds)
      end
    end

    class UuidDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeUuid]
      end

      def decode_with_type(cass_value) : Uuid
        handle_error(LibCass.value_get_uuid(cass_value, out cass_uuid))
        Uuid.new(cass_uuid)
      end
    end

    class TimeUuidDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeTimeuuid]
      end

      def decode_with_type(cass_value) : TimeUuid
        handle_error(LibCass.value_get_uuid(cass_value, out cass_uuid))
        TimeUuid.new(cass_uuid)
      end
    end

    class BooleanDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeBoolean]
      end

      def decode_with_type(cass_value) : Bool
        handle_error(LibCass.value_get_bool(cass_value, out val))
        val == CassTrue
      end
    end

    class ListDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeList]
      end

      def decode_with_type(cass_list) : Array(Primitive)
        subtype = LibCass.value_primary_sub_type(cass_list)
        decoder = BaseDecoder.get_decoder(subtype)
        item_count = LibCass.value_item_count(cass_list)
        collection = Array(Primitive).new(item_count)
        cass_iterator = LibCass.iterator_from_collection(cass_list)
        begin
          while LibCass.iterator_next(cass_iterator) == CassTrue
            cass_value = LibCass.iterator_get_value(cass_iterator)
            value = decoder.decode(cass_value).as(Primitive)
            collection << value
          end
          collection
        ensure
          LibCass.iterator_free(cass_iterator)
        end
      end
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

      private def append(cass_coll : LibCass::CassCollection, val : String)
        LibCass.collection_append_string_n(cass_coll, val, val.size)
      end
    end
  end
end
