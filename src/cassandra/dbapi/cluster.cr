require "../libcass"

module Cassandra
  module DBApi
    # Represents a Cassandra cluster. Stores connection parameters like host and
    # port. A single cluster can be used to create many sessions so a custom
    # reference counting mechanism is used to track and destroy sessions as
    # needed.
    class Cluster
      @@clusters = {} of String => Cluster

      def self.acquire(context : DB::ConnectionContext)
        uri_s = context.uri.to_s
        cluster = @@clusters.fetch(uri_s) do
          @@clusters[uri_s] = Cluster.new(context)
        end
        cluster.add_reference
      end

      # Track how many times this instance has been acquired.
      @acquire_count = Atomic(Int32).new(0)
      @uri_s : String
      getter paging_size : UInt64?

      @cass_cluster : LibCass::CassCluster

      # Initialises a cluster object with the supplied host and port from the
      # *context*.
      def initialize(context : DB::ConnectionContext)
        @uri_s = context.uri.to_s
        @cass_cluster = LibCass.cluster_new

        host = context.uri.host || "127.0.0.1"
        LibCass.cluster_set_contact_points(@cass_cluster, host)

        port = context.uri.port
        LibCass.cluster_set_port(@cass_cluster, port) if port

        user = context.uri.user
        password = context.uri.password
        if user && password
          LibCass.cluster_set_credentials(@cass_cluster, user, password)
        end

        params = HTTP::Params.parse(context.uri.query || "")
        @paging_size = params["paging_size"]?.try(&.to_u64?)
      end

      # Close the connection.
      #
      # Disposes the cluster when the last reference is removed. Needs to be
      # called to prevent memory leaks.
      def do_close
        @acquire_count.sub(1)
        return if @acquire_count.get > 0

        # All references returned. Destruct self.
        LibCass.cluster_free(@cass_cluster)
        @@clusters.delete(@uri_s)
      end

      # :nodoc:
      def to_unsafe
        @cass_cluster
      end

      protected def add_reference
        @acquire_count.add(1)
        self
      end
    end
  end
end
