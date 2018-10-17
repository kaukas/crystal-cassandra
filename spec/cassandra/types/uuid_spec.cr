require "spec"
require "../../../src/cassandra/dbapi"

alias Uuid = Cassandra::DBApi::Uuid

describe Uuid do
  describe "#initialize" do
    it "can be created from string" do
      Uuid.new("550e8400-e29b-41d4-a716-446655440000").to_s.
        should eq("550e8400-e29b-41d4-a716-446655440000")
    end

    it "raises an error if the string is shorter than 36 characters" do
      expect_raises(Cassandra::DBApi::CommonUuid::UuidError) do
        Uuid.new("550e8400-e29b-41d4-a716-44665544000")
      end
    end

    it "raises an error if the string is longer than 36 characters" do
      expect_raises(Cassandra::DBApi::CommonUuid::UuidError) do
        Uuid.new("550e8400-e29b-41d4-a716-4466554400000")
      end
    end

    it "raises an error if the string is not a hexadecimal number" do
      expect_raises(Cassandra::DBApi::CommonUuid::UuidError) do
        Uuid.new("550e8400-e29b-41d4-a716-44665544000x")
      end
    end
  end

  describe "#==" do
    it "is equal to another Uuid with the same value" do
      Uuid.new("550e8400-e29b-41d4-a716-446655440000").
        should eq(Uuid.new("550e8400-e29b-41d4-a716-446655440000"))
    end

    it "is not equal to another Uuid with a different value" do
      Uuid.new("550e8400-e29b-41d4-a716-446655440000").
        should_not eq(Uuid.new("550e8400-e29b-41d4-a716-446655440009"))
    end
  end

  # TODO: hash
end
