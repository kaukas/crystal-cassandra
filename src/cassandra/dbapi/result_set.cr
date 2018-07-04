require "db"
require "../libcass"

module Cassandra
  module DBApi
    class IteratorError < DB::Error
    end

    class ResultSet < DB::ResultSet
      CassTrue = LibCass::CassBoolT::CassTrue

      @cass_column_iterator : LibCass::CassIterator | Nil

      def initialize(statement : Statement,
                     @cass_result_future : LibCass::CassFuture)
        super(statement)
        @cass_result = LibCass.cass_future_get_result(@cass_result_future)
        @cass_row_iterator = LibCass.cass_iterator_from_result(@cass_result)
      end

      def do_close
        free_column_iterator
        LibCass.cass_iterator_free(@cass_row_iterator)
        LibCass.cass_result_free(@cass_result)
        LibCass.cass_future_free(@cass_result_future)
      end

      def move_next
        has_next = LibCass.cass_iterator_next(@cass_row_iterator) == CassTrue
        if has_next
          free_column_iterator
          cass_row = LibCass.cass_iterator_get_row(@cass_row_iterator)
          @cass_column_iterator = LibCass.cass_iterator_from_row(cass_row)
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
        it = @cass_column_iterator || raise IteratorError.new("Either `move_next` not called or no more rows")
        if LibCass.cass_iterator_next(it) != CassTrue
          raise IteratorError.new("No more values in this row")
        end
        cass_value = LibCass.cass_iterator_get_column(it)
        decode_value(cass_value)
      end

      private def free_column_iterator
        col_iterator = @cass_column_iterator
        LibCass.cass_iterator_free(col_iterator) if col_iterator
      end

      private def decode_value(cass_value : LibCass::CassValue)
        DBTypeRegistry.from_db(cass_value)
      end
    end
  end
end
