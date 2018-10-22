require "db"
require "../libcass"

module Cassandra
  module DBApi
    # Represents a Cassandra session, establishes the actual connection to
    # Cassandra.
    class Session
      # Wraps connection errors returned by the cpp-driver.
      class ConnectError < DB::Error
      end

      @cass_session : LibCass::CassSession

      # Creates a `Session` object and initiates a connection to Cassandra.
      def initialize(cluster : Cluster, context : DB::ConnectionContext)
        @cass_session = create_session
        connect(cluster, context.uri.path)
      end

      # :nodoc:
      def to_unsafe
        @cass_session
      end

      # :nodoc:
      def create_session
        LibCass.session_new
      end

      # :nodoc:
      def connect(cluster : Cluster, path : String?)
        keyspace = if path && path.size > 1
                     path[1..-1]
                   else
                     nil
                   end
        cass_connect_future = if keyspace
                                LibCass.session_connect_keyspace(@cass_session,
                                                                 cluster,
                                                                 keyspace)
                              else
                                LibCass.session_connect(@cass_session, cluster)
                              end
        Error.from_future(cass_connect_future, ConnectError)
        LibCass.future_free(cass_connect_future)
      end

      # Close the session.
      #
      # Closes the Cassandra connection and frees memory. Needs to be called to
      # prevent connection and memory leaks.
      def do_close
        LibCass.session_free(@cass_session)
      end
    end
  end
end
