require "db"
require "../libcass"

module Cassandra
  module DBApi
    EPOCH_START = ::Time.unix(0)

    # Implements functionality common to both `Uuid` and `TimeUuid`.
    module CommonUuid
      GENERATOR = LibCass.uuid_gen_new

      # An error
      class UuidError < DB::Error
      end

      @cass_uuid : LibCass::CassUuid

      private def from_string(s : String)
        Error.from_error(LibCass.uuid_from_string_n(s, s.size, out cass_uuid),
                         UuidError)
        cass_uuid
      end

      def to_unsafe
        @cass_uuid
      end

      # Renders the UUID to a string.
      def to_s
        # Strings are immutable. Create an array of C chars instead.
        output = Array(LibC::Char).new(LibCass::UUID_STRING_LENGTH, 0).to_unsafe
        LibCass.uuid_string(@cass_uuid, output)
        # Omit the final \0 char.
        String.new(output, LibCass::UUID_STRING_LENGTH - 1)
      end
    end

    # Represents the Cassandra *uuid* type.
    struct Uuid
      include CommonUuid

      # Autogenerates a UUID.
      def initialize
        LibCass.uuid_gen_random(GENERATOR, out @cass_uuid)
      end

      # Initialises the UUID from a string.
      def initialize(s : String)
        @cass_uuid = from_string(s)
      end

      # Initialises the UUID from a Cassandra UUID.
      def initialize(@cass_uuid)
      end
    end

    # Represents the Cassandra *timeuuid* type.
    struct TimeUuid
      include CommonUuid

      # Autogenerates a Time UUID.
      def initialize
        LibCass.uuid_gen_time(GENERATOR, out @cass_uuid)
      end

      # Initialises the UUID from a string.
      def initialize(s : String)
        @cass_uuid = from_string(s)
      end

      # Initialises the UUID from a Cassandra UUID.
      def initialize(@cass_uuid)
      end

      # Extracts the time part of the *timeuuid*.
      def to_time : ::Time
        milliseconds = LibCass.uuid_timestamp(@cass_uuid)
        EPOCH_START + ::Time::Span.new(nanoseconds: milliseconds * 1_000_000)
      end
    end

    # Represents the Cassandra *date* type.
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

    # Represents the Cassandra *time* type.
    struct Time
      getter time

      def initialize(@time : ::Time)
      end

      def initialize(nanoseconds : Int64)
        @time = EPOCH_START + ::Time::Span.new(nanoseconds: nanoseconds)
      end

      def total_nanoseconds : Int64
        (@time - @time.at_beginning_of_day).total_nanoseconds.to_i64
      end

      def ==(other : self) : Bool
        @time == other.time
      end

      def to_s
        @time.to_s
      end
    end
  end
end
