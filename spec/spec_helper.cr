require "spec"

module DBHelper
  def self.setup
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
    uri = "cassandra://root@127.0.0.1/crystal_cassandra_dbapi_test?#{params}"
    DB.open(uri) { |db| yield(db) }
  end
end
