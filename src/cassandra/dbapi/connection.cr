require "db"
require "../libcass"

module Cassandra
  module DBApi
    class ConnectError < DB::Error
    end

    class Cluster
      @cass_cluster : LibCass::CassCluster

      def initialize(context : DB::ConnectionContext)
        host = context.uri.host || "127.0.0.1"
        # port = context.uri.port
        # port_s = port ? ":#{port}" : ""
        # address = "#{host}#{port_s}"
        # addresses = [address].join(',')
        addresses = host

        # @closed = false
        @cass_cluster = LibCass.cass_cluster_new
        LibCass.cass_cluster_set_contact_points(@cass_cluster, host)
      end

      def close
        # return if @closed
        LibCass.cass_cluster_free(@cass_cluster)
        # @closed = true
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
        # @closed = false
        LibCass.cass_session_new
      end

      def connect(cluster : Cluster, path : String?)
        keyspace = if path && path.size > 1
                     path[1..-1]
                   else
                     nil
                   end
        connect_future = if keyspace
                           LibCass.cass_session_connect_keyspace(@cass_session,
                                                                 cluster,
                                                                 keyspace)
                         else
                           LibCass.cass_session_connect(@cass_session, cluster)
                         end
        Error.from_future(connect_future, ConnectError)
        connect_future
      end

      def close
        # return if @closed
        LibCass.cass_session_free(@cass_session)
        # @closed = true
      end

      # def execute(statement : String)
      #   Statements::Simple.new(statement).accept(self)
      # end
    end

    class Connection < DB::Connection
      getter session : DBApi::Session

      def initialize(context : DB::ConnectionContext)
        super(context)
        @cluster = Cluster.new(context)
        @session = DBApi::Session.new(@cluster, context)
        # @connect_future = connect
      end

      def do_close
        # close_future
        @session.close
        @cluster.close
      end

      # def close_future
      #   return if @closed
      #   LibCass.cass_future_free(@connect_future)
      #   @closed = true
      # end

      def build_prepared_statement(query)
        Statement.new(self, query)
      end

      def build_unprepared_statement(query)
        Statement.new(self, query)
      end

      # def connect
      #   @closed = false
      #   connect_future = LibCass.cass_session_connect(@session, @cluster)
      #   Error.from_future(connect_future, ConnectError)
      #   connect_future
      # end
    end
  end
end