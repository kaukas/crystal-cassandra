require "../spec_helper"
require "../../src/cassandra/dbapi"

Spectator.describe "Error handling" do
  before_all do
    DBHelper.setup

    DBHelper.connect do |db|
      db.exec "drop table if exists books"
      db.exec "create table books (id timeuuid primary key, page_count int)"
    end
  end

  let(db) { DBHelper.connect }

  after_each { db.close }

  it "reports the types of bind param expected and received" do
    expect_raises(Cassandra::DBApi::ValueBinder::BindError,
                  /"42".*of type String.*index 0/m) do
      db.exec("insert into books (id, page_count) values (now(), ?)", "42")
    end
  end

  it "cuts very long values in the error message" do
    count = "a" * 2000
    expect_raises(Cassandra::DBApi::ValueBinder::BindError, /"a{1000}…/) do
      db.exec("insert into books (id, page_count) values (now(), ?)", count)
    end
  end
end
