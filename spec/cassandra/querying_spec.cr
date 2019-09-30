require "../spec_helper"
require "../../src/cassandra/dbapi"

describe "Querying" do
  DBHelper.setup

  DBHelper.connect("paging_size=1") do |db|
    db.exec "drop table if exists books"
    db.exec "create table books (id timeuuid primary key, title varchar)"

    it "performs result page handling automatically" do
      titles = Array.new(5) { |i| i.to_s }.to_set
      titles.each do |title|
        db.exec("insert into books (id, title) values (now(), ?)", title)
      end

      fetched_titles = Set(String).new
      db.query("select title from books") do |rs|
        rs.each { fetched_titles << rs.read(String) }
      end
      fetched_titles.should eq(titles)
    end

    it "resets paging state between requests" do
      titles = Array.new(5) { |i| i.to_s }.to_set
      titles.each do |title|
        db.exec("insert into books (id, title) values (now(), ?)", title)
      end

      2.times do
        fetched_titles = Set(String).new
        db.query("select title from books") do |rs|
          rs.each { fetched_titles << rs.read(String) }
        end
        fetched_titles.should eq(titles)
      end
    end
  end

  DBHelper.connect("prepared_statements=true") do |db|
    db.exec "drop table if exists books"
    db.exec "create table books (id timeuuid primary key, title varchar)"

    it "throws errors on invalid prepared statements" do
      # Expect a valid statement to succeed.
      db.exec("insert into books (id, title) values (now(), ?)", "A title")
      # Expect an invalid statement to fail.
      expect_raises(Cassandra::DBApi::PreparedStatement::StatementPrepareError,
                    "ErrorServerSyntaxError") do
        db.exec("do not insert into books (id, title) values (now(), ?)")
      end
    end
  end

  DBHelper.connect("prepared_statements=false") do |db|
    db.exec "drop table if exists books"
    db.exec "create table books (id timeuuid primary key, title varchar)"

    it "throws errors on invalid unprepared statements" do
      # Expect a valid statement to succeed.
      db.exec("insert into books (id, title) values (now(), ?)", "A title")
      # Expect an invalid statement to fail.
      expect_raises(Cassandra::DBApi::StatementError,
                    "ErrorServerSyntaxError") do
        db.exec("do not insert into books (id, title) values (now(), ?)")
      end
    end
  end
end
