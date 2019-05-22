require "db"
require "../libcass"
require "./types"
require "./decoders"

module Cassandra
  module DBApi
    class ResultSet < DB::ResultSet
      class IteratorError < DB::Error
      end

      CassTrue = LibCass::BoolT::True
      ITERATION_ERROR = IteratorError.new("No more values in this row")

      @cass_column_iterator : LibCass::CassIterator | Nil
      @decoders : Array(Decoders::BaseDecoder)

      def initialize(statement : RawStatement,
                     @cass_result_future : LibCass::CassFuture)
        super(statement)
        @cass_result = LibCass.future_get_result(@cass_result_future)
        @cass_row_iterator = LibCass.iterator_from_result(@cass_result)
        @decoders = Array.new(column_count) do |i|
          cass_value_type = LibCass.result_column_type(@cass_result, i)
          Decoders::BaseDecoder.get_decoder(cass_value_type)
        end
        @col_index = 0
      end

      def do_close
        free_column_iterator
        LibCass.iterator_free(@cass_row_iterator)
        LibCass.result_free(@cass_result)
        LibCass.future_free(@cass_result_future)
        super
      end

      def move_next : Bool
        has_next = LibCass.iterator_next(@cass_row_iterator) == CassTrue
        if has_next
          free_column_iterator
          cass_row = LibCass.iterator_get_row(@cass_row_iterator)
          @cass_column_iterator = LibCass.iterator_from_row(cass_row)
          # Wanted to use a @decoder_iterator but Crystal complains that the
          # type of `read` should be NoReturn.
          @col_index = 0
        end
        has_next
      end

      def column_count
        LibCass.result_column_count(@cass_result)
      end

      def column_name(i : Int32) : String
        LibCass.result_column_name(@cass_result, i, out name, out _len)
        String.new(name)
      end

      def read
        decoder = get_next_decoder
        cass_value = read_next_column
        decoder.decode(cass_value)
      end

      private def read_next_column : LibCass::CassValue
        it = @cass_column_iterator || raise ITERATION_ERROR
        raise ITERATION_ERROR if LibCass.iterator_next(it) != CassTrue
        LibCass.iterator_get_column(it)
      end

      private def get_next_decoder : Decoders::BaseDecoder
        @decoders[@col_index].tap do
          @col_index += 1
        end
      end

      private def free_column_iterator
        col_iterator = @cass_column_iterator
        LibCass.iterator_free(col_iterator) if col_iterator
      end
    end
  end
end
