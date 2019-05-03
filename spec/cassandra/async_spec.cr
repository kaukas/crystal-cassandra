require "../spec_helper"
require "../../src/cassandra/dbapi"

describe "Async" do
  DBHelper.setup

  DBHelper.connect do |db|
    db.exec "drop table if exists books"
    db.exec "create table books (id timeuuid primary key, title text)"

    Spec.before_each do
      db.exec "truncate table books"
    end

    it "runs queries asynchronously" do
      db.exec("insert into books (id, title) values (now(), ?)", "History")
      chan = Channel(String).new

      spawn do
        db.query("select title from books") do |rs|
          rs.each { chan.send("0: #{rs.read(String)}") }
        end
      end

      spawn do
        chan.send("1: query")
        db.query("select title from books") do |rs|
          rs.each { chan.send("1: #{rs.read(String)}") }
        end
      end

      # Expecting ["1: query", "0: History", "1: History"] but the order of
      # query results is undefined. Still, the second fiber should have a chance
      # to run.
      Array.new(3) { chan.receive }.first.should eq("1: query")
    end
  end
end
