require "db"
require "../libcass"
require "./types"

module Cassandra
  module DBApi
    class IteratorError < DB::Error
    end

    class ResultSet < DB::ResultSet
      CassTrue = LibCass::CassBoolT::CassTrue
      ITERATION_ERROR = IteratorError.new("No more values in this row")

      @cass_column_iterator : LibCass::CassIterator | Nil
      @decoders : Array(BaseDecoder)

      def initialize(statement : Statement,
                     @cass_result_future : LibCass::CassFuture)
        super(statement)
        @cass_result = LibCass.cass_future_get_result(@cass_result_future)
        @cass_row_iterator = LibCass.cass_iterator_from_result(@cass_result)
        @decoders = Array.new(column_count) do |i|
          cass_value_type = LibCass.cass_result_column_type(@cass_result, i)
          BaseDecoder.get_decoder(cass_value_type)
        end
        @col_index = 0
      end

      def do_close
        free_column_iterator
        LibCass.cass_iterator_free(@cass_row_iterator)
        LibCass.cass_result_free(@cass_result)
        LibCass.cass_future_free(@cass_result_future)
      end

      def move_next : Bool
        has_next = LibCass.cass_iterator_next(@cass_row_iterator) == CassTrue
        if has_next
          free_column_iterator
          cass_row = LibCass.cass_iterator_get_row(@cass_row_iterator)
          @cass_column_iterator = LibCass.cass_iterator_from_row(cass_row)
          # Wanted to use a @decoder_iterator but Crystal complains that the
          # type of `read` should be NoReturn.
          @col_index = 0
        end
        has_next
      end

      def column_count
        LibCass.cass_result_column_count(@cass_result)
      end

      def column_name(i : Int32) : String
        LibCass.cass_result_column_name(@cass_result, i, out name, out _len)
        String.new(name)
      end

      def read
        decoder = get_next_decoder
        cass_value = read_next_column
        decoder.decode(cass_value)
      end

      private def read_next_column : LibCass::CassValue
        it = @cass_column_iterator || raise ITERATION_ERROR
        if LibCass.cass_iterator_next(it) != CassTrue
          raise ITERATION_ERROR
        end
        LibCass.cass_iterator_get_column(it)
      end

      private def get_next_decoder : BaseDecoder
        @decoders[@col_index].tap do
          @col_index += 1
        end
      end

      private def free_column_iterator
        col_iterator = @cass_column_iterator
        LibCass.cass_iterator_free(col_iterator) if col_iterator
      end
    end
  end
end
