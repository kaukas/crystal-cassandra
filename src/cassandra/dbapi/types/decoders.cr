require "../../libcass"

module Cassandra
  module DBApi
    abstract class BaseDecoder
      @@cass_types_by_code = Hash(LibCass::CassValueType, BaseDecoder).new

      def decode(cass_value : LibCass::CassValue)
        if LibCass.value_is_null(cass_value) == CassTrue
          return nil
        else
          decode_with_type(cass_value)
        end
      end

      abstract def decode_with_type(cass_value : LibCass::CassValue)

      def handle_error(cass_error : LibCass::CassError)
        Error.from_error(cass_error)
      end

      def decode_iterator(iter : Iterator)
        iter.map { |item| Any.new(decode_with_type(item)).as(Any) }
      end

      protected def self.cass_value_codes : Array(LibCass::CassValueType)
        raise NotImplementedError.new("You need to derive `cass_value_codes`")
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
          @@cass_types_by_code[cass_value_code] = instance
        end
      end

      def self.get_decoder(cass_value_type : LibCass::CassValueType)
        @@cass_types_by_code[cass_value_type]
      end
    end

    class StringDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeAscii,
         LibCass::CassValueType::ValueTypeVarchar]
      end

      def decode_with_type(cass_value)
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

      def decode_with_type(cass_value)
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

      def decode_with_type(cass_value) : DBApi::Date
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

      def decode_with_type(cass_value)
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

      def decode_with_type(cass_list)
        subtype = LibCass.value_primary_sub_type(cass_list)
        decoder = BaseDecoder.get_decoder(subtype)
        decoder.decode_iterator(CassCollectionIterator.new(cass_list)).to_a
      end
    end

    class SetDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeSet]
      end

      def decode_with_type(cass_set)
        subtype = LibCass.value_primary_sub_type(cass_set)
        decoder = BaseDecoder.get_decoder(subtype)
        decoder.decode_iterator(CassCollectionIterator.new(cass_set)).to_set
      end
    end

    class MapDecoder < BaseDecoder
      def self.cass_value_codes
        [LibCass::CassValueType::ValueTypeMap]
      end

      def decode_with_type(cass_map)
        key_type = LibCass.value_primary_sub_type(cass_map)
        key_decoder = BaseDecoder.get_decoder(key_type)
        keys = key_decoder.decode_iterator(CassMapKeyIterator.new(cass_map))

        val_type = LibCass.value_secondary_sub_type(cass_map)
        val_decoder = BaseDecoder.get_decoder(val_type)
        vals = val_decoder.decode_iterator(CassMapValueIterator.new(cass_map))

        count_of_items = LibCass.value_item_count(cass_map)
        hsh = Hash(Any, Any).new(nil, count_of_items)
        keys.zip(vals).each do |(key, val)|
          hsh[key] = val
        end
        hsh
      end
    end
  end
end
