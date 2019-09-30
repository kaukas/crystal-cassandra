module Cassandra
  module DBApi
    # TODO: Perhaps use https://github.com/dhruvrajvanshi/crz
    module Error
      def self.from_future(cass_future : LibCass::CassFuture, err_class : Class)
        # Give other fibers a chance while we're waiting for the future to
        # resolve.
        Fiber.yield

        error_code = LibCass.future_error_code(cass_future)
        return if error_code == LibCass::CassError::Ok

        # TODO: handle errors properly, with tests.
        LibCass.future_error_message(cass_future, out msg, out len)
        error_message = String.new(msg, len)
        raise err_class.new("#{error_code}: #{error_message}")
      end

      # TODO: handle errors properly, with tests.
      def self.from_error(cass_error : LibCass::CassError,
                          err_class = DB::Error)
        if cass_error != LibCass::CassError::Ok
          raise err_class.new(cass_error.to_s)
        end
      end
    end
  end
end
