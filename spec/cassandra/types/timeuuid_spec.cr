require "spec"
require "../../../src/cassandra/dbapi"

alias TimeUuid = Cassandra::DBApi::TimeUuid

describe TimeUuid do
  describe "#to_time" do
    it "returns a Time" do
      uuid = TimeUuid.new("00b69180-d0e1-11e2-8b8b-0800200c9a66")
      uuid.to_time.should be > ::Time.utc(2013, 6, 9, 8, 45, 57)
      uuid.to_time.should be < ::Time.utc(2013, 6, 9, 8, 45, 58)
    end
  end

  # TODO:
  # describe "#<=>" do
  #   it "sorts by the time component" do
  #     
  #   end
  # end
end
