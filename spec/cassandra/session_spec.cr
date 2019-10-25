require "../spec_helper"

Spectator.describe Cassandra::DBApi do
  before_all do
    DBHelper.setup
  end

  it "supports a custom port" do
    # Expect correct port to succeed.
    DB.open("cassandra://root@127.0.0.1:9042")
    # Expect incorrect port to fail.
    expect_raises(Cassandra::DBApi::Session::ConnectError,
                  /ErrorLibNoHostsAvailable/) do
      DB.open("cassandra://root@127.0.0.1:55")
    end
  end

  it "supports multiple hosts" do
    # Expect the last address to succeed.
    DB.open("cassandra://root@127.0.0.3,127.0.0.2,127.0.0.1:9042")
  end

  it "supports connecting to a particular keyspace" do
    # Expect correct keyspace to succeed.
    DB.open("cassandra://root@127.0.0.1:9042/crystal_cassandra_dbapi_test")
    # Expect incorrect keyspace to fail.
    expect_raises(Cassandra::DBApi::Session::ConnectError,
                  /ErrorLibUnableToSetKeyspace/) do
      DB.open("cassandra://root@127.0.0.1:9042/onaoweingaowifaowinow")
    end
  end
end
