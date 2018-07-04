# TODO: perhaps use https://github.com/dhruvrajvanshi/crz
module Cassandra
  module DBApi
    module Error
      def self.from_future(cass_future : LibCass::CassFuture | Nil,
                           err_class : Class)
        return if cass_future.is_a?(Nil)
        error_code = LibCass.cass_future_error_code(cass_future)
        # TODO: handle errors properly, with tests.
        unless error_code == LibCass::CassError::CassOk
          LibCass.cass_future_error_message(cass_future, out msg, out len)
          error_message = String.new(msg, len)
          LibCass.cass_future_free(cass_future)
          puts "Future error: #{error_code} #{error_message}"
          raise err_class.new("#{error_code}: #{error_message}")
        end
      end
    end
  end
end
