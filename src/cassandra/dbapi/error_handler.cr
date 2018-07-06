# TODO: perhaps use https://github.com/dhruvrajvanshi/crz
module Cassandra
  module DBApi
    module Error
      def self.from_future(cass_future : LibCass::CassFuture | Nil,
                           err_class : Class)
        return if cass_future.is_a?(Nil)
        error_code = LibCass.future_error_code(cass_future)
        # TODO: handle errors properly, with tests.
        unless error_code == LibCass::CassError::CassOk
          LibCass.future_error_message(cass_future, out msg, out len)
          error_message = String.new(msg, len)
          LibCass.future_free(cass_future)
          raise err_class.new("#{error_code}: #{error_message}")
        end
      end

      # TODO: handle errors properly, with tests.
      def self.from_error(cass_error : LibCass::CassError,
                          err_class = DB::Error)
        if cass_error != LibCass::CassError::CassOk
          raise err_class.new(cass_error.to_s)
        end
      end
    end
  end
end
