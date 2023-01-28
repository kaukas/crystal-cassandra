require "db"
require "../libcass"
require "./session"
require "./statement"
require "./types"
require "./decoders"

module Cassandra
  module DBApi
    CassTrue = LibCass::BoolT::True

    private class ResultPageIterator
      include Iterator(LibCass::CassResult)

      @session : Session
      @statement : RawStatement
      @cass_result : LibCass::CassResult?

      def initialize(@session, @statement)
        @statement.reset_paging_state
      end

      def do_close
        LibCass.result_free(@cass_result.not_nil!)
      end

      def next
        cass_result = @cass_result
        if cass_result.nil?
          get_next_result.tap { |result| @cass_result = result }
        elsif LibCass.result_has_more_pages(cass_result) == CassTrue
          Error.from_error(LibCass.statement_set_paging_state(@statement,
                                                              cass_result))
          get_next_result.tap do |result|
            do_close
            @cass_result = result
          end
        else
          stop
        end
      end

      private def get_next_result
        cass_result_future = LibCass.session_execute(@session, @statement)
        begin
          Error.from_future(cass_result_future, StatementError)
          LibCass.future_get_result(cass_result_future)
        ensure
          LibCass.future_free(cass_result_future)
        end
      end
    end

    class ResultSet < DB::ResultSet
      class IteratorError < DB::Error
      end
      ITERATION_ERROR = IteratorError.new("No more values in this row")

      @result_pages : ResultPageIterator
      getter column_count : Int32
      @column_names : Array(String)
      @decoders : Array(Decoders::BaseDecoder)
      @cass_row_iterator : LibCass::CassIterator
      @cass_column_iterator : LibCass::CassIterator?

      def initialize(session : Session, statement : RawStatement)
        super(statement)
        @result_pages = ResultPageIterator.new(session, statement)

        cass_result = @result_pages.next
        raise "Unexpected iteration end" if cass_result.is_a?(Iterator::Stop)

        @cass_row_iterator = LibCass.iterator_from_result(cass_result)

        @column_count = LibCass.result_column_count(cass_result).to_i32
        @column_names = Array.new(@column_count) do |i|
          LibCass.result_column_name(cass_result, i, out name, out _len)
          String.new(name)
        end

        @decoders = Array.new(@column_count) do |i|
          cass_value_type = LibCass.result_column_type(cass_result, i)
          Decoders::BaseDecoder.get_decoder(cass_value_type)
        end
        @col_index = 0
      end

      def do_close
        free_column_iterator
        free_row_iterator
        @result_pages.do_close
        super
      end

      def move_next : Bool
        free_column_iterator
        @col_index = 0

        has_next = LibCass.iterator_next(@cass_row_iterator) == CassTrue
        unless has_next
          cass_result = @result_pages.next
          if cass_result.is_a?(LibCass::CassResult)
            free_row_iterator
            @cass_row_iterator = LibCass.iterator_from_result(cass_result)
            has_next = LibCass.iterator_next(@cass_row_iterator) == CassTrue
          end
        end

        if has_next
          cass_row = LibCass.iterator_get_row(@cass_row_iterator)
          @cass_column_iterator = LibCass.iterator_from_row(cass_row)
          # Wanted to use a @decoder_iterator but Crystal complains that the
          # type of `read` should be NoReturn.
        end

        has_next
      end

      def column_name(index : Int32) : String
        @column_names[index]
      end

      def next_column_index : Int32
        @col_index + 1
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
        if column_iterator = @cass_column_iterator
          LibCass.iterator_free(column_iterator)
          @cass_column_iterator = nil
        end
      end

      private def free_row_iterator
        LibCass.iterator_free(@cass_row_iterator)
      end
    end
  end
end
