require "../libcass"

module Cassandra
  module DBApi
    class Session
      @cass_session : LibCass::CassSession

      def initialize(cluster : Cluster, context : DB::ConnectionContext)
        @cass_session = create_session
        connect(cluster, context.uri.path)
      end

      def to_unsafe
        @cass_session
      end

      def create_session
        LibCass.session_new
      end

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

      def close
        LibCass.session_free(@cass_session)
      end
    end
  end
end
