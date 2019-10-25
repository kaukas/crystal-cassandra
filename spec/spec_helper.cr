require "spectator"
require "../src/cassandra/dbapi"

module DBHelper
  def self.setup
    Cassandra::LibCass.log_set_level(
      Cassandra::LibCass::CassLogLevel::LogDisabled
    )

    DB.open("cassandra://root@127.0.0.1") do |db|
      db.exec "drop keyspace if exists crystal_cassandra_dbapi_test"
      db.exec <<-CQL
        create keyspace crystal_cassandra_dbapi_test
        with replication = { 'class': 'SimpleStrategy',
                             'replication_factor': 1 }
      CQL
    end
  end

  def self.connect(params : String = "")
    DB.open(db_uri(params)) { |db| yield(db) }
  end

  def self.connect(params : String = "")
    DB.open(db_uri(params))
  end

  private def self.db_uri(params : String)
    "cassandra://root@127.0.0.1/crystal_cassandra_dbapi_test?#{params}"
  end
end
