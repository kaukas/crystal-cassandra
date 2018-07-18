require "db"
require "./session"
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
        PreparedStatement.new(self, query)
      end

      def build_unprepared_statement(query)
        RawStatement.new(self, query)
      end
    end
  end
end
