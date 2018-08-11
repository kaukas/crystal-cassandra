require "db"
require "../libcass"
require "./types/decoders"
require "./types/binders"

module Cassandra
  module DBApi
    EPOCH_START = ::Time.epoch(0)
    CassTrue = LibCass::BoolT::True
    CassFalse = LibCass::BoolT::False

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

    class CassCollectionIterator
      include Iterator(LibCass::CassValue)

      def initialize(cass_list : LibCass::CassValue)
        @cass_iterator = LibCass.iterator_from_collection(cass_list)
      end

      def finalize
        LibCass.iterator_free(@cass_iterator)
      end

      def next
        if LibCass.iterator_next(@cass_iterator) == CassTrue
          LibCass.iterator_get_value(@cass_iterator)
        else
          stop
        end
      end
    end

    module CassMapIterator
      include Iterator(LibCass::CassValue)

      def initialize(cass_map : LibCass::CassValue)
        @cass_iterator = LibCass.iterator_from_map(cass_map)
      end

      def finalize
        LibCass.iterator_free(@cass_iterator)
      end

      def next
        if LibCass.iterator_next(@cass_iterator) == CassTrue
          parse_val(@cass_iterator)
        else
          stop
        end
      end
    end

    class CassMapKeyIterator
      include CassMapIterator

      def parse_val(cass_iterator)
        LibCass.iterator_get_map_key(cass_iterator)
      end
    end

    class CassMapValueIterator
      include CassMapIterator

      def parse_val(cass_iterator)
        LibCass.iterator_get_map_value(cass_iterator)
      end
    end
  end
end
