require "db"
require "../libcass"
require "./cluster"

module Cassandra
  module DBApi
    # Represents a Cassandra session, establishes the actual connection to
    # Cassandra.
    class Session < DB::Connection
      # Wraps connection errors returned by the cpp-driver.
      class ConnectError < DB::Error
      end

      @cass_session : LibCass::CassSession
      @cluster : Cluster

      # Creates a `Session` object and initiates a Cassandra cluster.
      def initialize(context : DB::ConnectionContext)
        super(context)
        @cluster = Cluster.acquire(context)
        @cass_session = LibCass.session_new
        connect(context.uri.path)
      end

      # :nodoc:
      def to_unsafe
        @cass_session
      end

      # :nodoc:
      def connect(path : String?)
        keyspace = if path && path.size > 1
                     URI.decode(path[1..-1])
                   else
                     nil
                   end
        cass_connect_future = if keyspace
                                LibCass.session_connect_keyspace(@cass_session,
                                                                 @cluster,
                                                                 keyspace)
                              else
                                LibCass.session_connect(@cass_session, @cluster)
                              end
        begin
          Error.from_future(cass_connect_future, ConnectError)
        ensure
          LibCass.future_free(cass_connect_future)
        end
      end

      # Close the session.
      #
      # Closes the Cassandra session and frees memory. Also invokes cluster
      # disposal which will actually happen if this cluster reference is the
      # last one for that cluster. Needs to be called to prevent connection and
      # memory leaks.
      def do_close
        LibCass.session_free(@cass_session)
        @cluster.do_close
      end

      # Creates a prepared statement from a *query*.
      #
      # The statement is bound to a session and can be executed.
      def build_prepared_statement(query) : DB::Statement
        PreparedStatement.new(self, query, @cluster.paging_size)
      end

      # Creates an unprepared (one-off) statement from a *query*.
      #
      # The statement is bound to a session and can be executed.
      def build_unprepared_statement(query) : DB::Statement
        RawStatement.new(self, query, @cluster.paging_size)
      end
    end
  end
end
