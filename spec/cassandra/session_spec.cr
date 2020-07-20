require "../spec_helper"

Spectator.describe Cassandra::DBApi do
  before_all do
    DBHelper.setup
  end

  DB_URI = "cassandra://cassandra:cassandra@127.0.0.1:9042"

  it "supports a custom port" do
    # Expect correct port to succeed.
    DB.open(DB_URI)
    # Expect incorrect port to fail.
    expect_raises(Cassandra::DBApi::Session::ConnectError,
                  /ErrorLibNoHostsAvailable/) do
      DB.open("cassandra://cassandra:cassandra@127.0.0.1:55")
    end
  end

  it "supports multiple hosts" do
    # Expect the last address to succeed.
    DB.open(
      "cassandra://cassandra:cassandra@127.0.0.3,127.0.0.2,127.0.0.1:9042"
    )
  end

  it "supports URL encoded hosts" do
    # Expect the last address to succeed.
    hosts = URI.encode("127.0.0.3,127.0.0.2,127.0.0.1")
    DB.open("cassandra://cassandra:cassandra@#{hosts}:9042")
  end

  it "supports connecting to a particular keyspace" do
    # Expect correct keyspace to succeed.
    DB.open("#{DB_URI}/crystal_cassandra_dbapi_test")
    # Expect incorrect keyspace to fail.
    expect_raises(Cassandra::DBApi::Session::ConnectError,
                  /ErrorLibUnableToSetKeyspace/) do
      DB.open("#{DB_URI}/onaoweingaowifaowinow")
    end
  end

  it "supports quoted keyspace name" do
    keyspace = URI.encode(%("crystal_cassandra_dbapi_test"))
    # Expect correct keyspace to succeed.
    DB.open("#{DB_URI}/#{keyspace}")

    keyspace = URI.encode(%("onaoweingaowifaowinow"))
    # Expect incorrect keyspace to fail.
    expect_raises(Cassandra::DBApi::Session::ConnectError,
                  /ErrorLibUnableToSetKeyspace/) do
      DB.open("#{DB_URI}/#{keyspace}")
    end
  end

  it "sets correct credentials for authentication" do
    # Expect correct credentials to succeed.
    DB.open(DB_URI)
    # Expect incorrect credentials to fail.
    expect_raises(Cassandra::DBApi::Session::ConnectError,
                  /ErrorServerBadCredentials/) do
      DB.open("cassandra://incorrect:incorrect@127.0.0.1:9042")
    end
  end
end
