require "db"
require "../libcass"

module Cassandra
  module DBApi
    class ConnectError < DB::Error
    end

    class Cluster
      @cass_cluster : LibCass::CassCluster

      def initialize(context : DB::ConnectionContext)
        @cass_cluster = LibCass.cluster_new

        host = context.uri.host || "127.0.0.1"
        # TODO: support multiple addresses.
        LibCass.cluster_set_contact_points(@cass_cluster, host)

        port = context.uri.port
        if port
          LibCass.cluster_set_port(@cass_cluster, port)
        end
      end

      def close
        LibCass.cluster_free(@cass_cluster)
      end

      def to_unsafe
        @cass_cluster
      end
    end

    class Session
      @cass_session : LibCass::CassSession
      @connect_future : LibCass::CassFuture

      def initialize(cluster : Cluster, context : DB::ConnectionContext)
        @cass_session = create_session
        @connect_future = connect(cluster, context.uri.path)
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
        connect_future = if keyspace
                           LibCass.session_connect_keyspace(@cass_session,
                                                            cluster,
                                                            keyspace)
                         else
                           LibCass.session_connect(@cass_session, cluster)
                         end
        Error.from_future(connect_future, ConnectError)
        connect_future
      end

      def close
        LibCass.session_free(@cass_session)
      end
    end

    class Connection < DB::Connection
      getter session : DBApi::Session

      def initialize(context : DB::ConnectionContext)
        super(context)
        @cluster = Cluster.new(context)
        @session = DBApi::Session.new(@cluster, context)
      end

      def do_close
        @session.close
        @cluster.close
      end

      def build_prepared_statement(query)
        Statement.new(self, query)
      end

      def build_unprepared_statement(query)
        Statement.new(self, query)
      end
    end
  end
end
