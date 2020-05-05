require "../spec_helper"

Spectator.describe Cassandra::DBApi do
  before_all do
    DBHelper.setup
  end

  URI = "cassandra://cassandra:cassandra@127.0.0.1:9042"

  it "supports a custom port" do
    # Expect correct port to succeed.
    DB.open(URI)
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

  it "supports connecting to a particular keyspace" do
    # Expect correct keyspace to succeed.
    DB.open("#{URI}/crystal_cassandra_dbapi_test")
    # Expect incorrect keyspace to fail.
    expect_raises(Cassandra::DBApi::Session::ConnectError,
                  /ErrorLibUnableToSetKeyspace/) do
      DB.open("#{URI}/onaoweingaowifaowinow")
    end
  end

  it "sets correct credentials for authentication" do
    # Expect correct credentials to succeed.
    DB.open(URI)
    # Expect incorrect credentials to fail.
    expect_raises(Cassandra::DBApi::Session::ConnectError,
                  /ErrorServerBadCredentials/) do
      DB.open("cassandra://incorrect:incorrect@127.0.0.1:9042")
    end
  end
end
