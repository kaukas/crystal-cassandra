require "spec"
require "../../../src/cassandra/dbapi"

alias Duration = Cassandra::DBApi::Duration

describe Cassandra::DBApi::Duration do
  it "can be created from months, days, and nanoseconds" do
    Duration.new(0, 1, 10_i64 * 60_i64 * 1_000_000_000_i64).to_s.
      should eq("P0000-00-01T00:10:00")
  end

  it "can be created from months, days, and time" do
    Duration.new(2, 15, Time::Span.new(10, 15, 20)).to_s.
      should eq("P0000-02-15T10:15:20")
  end
end
