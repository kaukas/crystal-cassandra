require "./session"
require "../libcass"

module Cassandra
  module DBApi
    # Represents a Cassandra cluster. Stores connection parameters, like host
    # and port.
    class Cluster
      @cass_cluster : LibCass::CassCluster

      # Initialises a cluster object with the supplied host and port from the
      # *context*.
      def initialize(context : DB::ConnectionContext)
        @cass_cluster = LibCass.cluster_new

        host = context.uri.host || "127.0.0.1"
        # TODO: support multiple addresses.
        LibCass.cluster_set_contact_points(@cass_cluster, host)

        port = context.uri.port
        LibCass.cluster_set_port(@cass_cluster, port) if port
      end

      # Close the connection.
      #
      # Disposes the cluster. Needs to be called to prevent memory leaks.
      def do_close
        LibCass.cluster_free(@cass_cluster)
      end

      # :nodoc:
      def to_unsafe
        @cass_cluster
      end
    end

    # Represents a Cassandra connection. It contains cluster configuration and a
    # session. The connection is also used to construct statements from strings.
    #
    # The wrapped cpp-driver session already maintains a connection pool so the
    # DB pool is unnecessary. Instead of creating Connection instances we
    # acquire the same instance.
    class Connection < DB::Connection
      @@connections = {} of String => Connection

      def self.acquire(context : DB::ConnectionContext)
        uri = context.uri.to_s
        connection = @@connections.fetch(uri) do
          @@connections[uri] = Connection.new(context)
        end
        connection.add_reference
      end

      # Return the session that can be used to issue Cassandra queries.
      getter session : DBApi::Session
      # Track how many times this instance has been acquired.
      @acquire_count = Atomic(Int32).new(0)
      @uri : String

      # Creates a connection.
      #
      # Creates a `Cluster` object to store configuration. Initialises a
      # session.
      def initialize(context : DB::ConnectionContext)
        super(context)
        @uri = context.uri.to_s
        @cluster = Cluster.new(context)
        @session = DBApi::Session.new(@cluster, context)
      end

      # Close the connection.
      #
      # Disposes the cluster and the session, closes the Cassandra connection.
      # Needs to be called to prevent connection and memory leaks. `crystal-db`
      # automatically calls *do_close* for the connections that it manages.
      def do_close
        @acquire_count.sub(1)
        if @acquire_count.get <= 0
          # All references returned. Destruct self.
          @session.do_close
          @cluster.do_close
          @@connections.delete(@uri)
        end
      end

      def add_reference
        @acquire_count.add(1)
        self
      end

      # Creates a prepared statement from a *query*.
      #
      # The statement is bound to a session and can be executed.
      def build_prepared_statement(query : String)
        PreparedStatement.new(self, query)
      end

      # Creates an unprepared (one-off) statement from a *query*.
      #
      # The statement is bound to a session and can be executed.
      def build_unprepared_statement(query : String)
        RawStatement.new(self, query)
      end
    end
  end
end
