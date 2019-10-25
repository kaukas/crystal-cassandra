require "../spec_helper"
require "../../src/cassandra/dbapi"

Spectator.describe "Querying" do
  before_all do
    DBHelper.setup

    DBHelper.connect do |db|
      db.exec "drop table if exists books"
      db.exec "create table books (id timeuuid primary key, title varchar)"
    end
  end

  after_each { db.close }

  before_each do
    db.exec "truncate table books"
  end

  context("pagination") do
    let(db) { DBHelper.connect("paging_size=1") }

    it "performs result page handling automatically" do
      titles = Array.new(5) { |i| i.to_s }.to_set
      titles.each do |title|
        db.exec("insert into books (id, title) values (now(), ?)", title)
      end

      fetched_titles = Set(String).new
      db.query("select title from books") do |rs|
        rs.each { fetched_titles << rs.read(String) }
      end
      expect(fetched_titles).to eq(titles)
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
        expect(fetched_titles).to eq(titles)
      end
    end
  end

  context("prepared statements") do
    let(db) { DBHelper.connect("prepared_statements=true") }

    it "throws errors on invalid prepared statements" do
      # Expect a valid statement to succeed.
      db.exec("insert into books (id, title) values (now(), ?)", "A title")
      # Expect an invalid statement to fail.
      expect_raises(Cassandra::DBApi::PreparedStatement::StatementPrepareError,
                    /ErrorServerSyntaxError/) do
        db.exec("do not insert into books (id, title) values (now(), ?)")
      end
    end
  end

  context("unprepared statements") do
    let(db) { DBHelper.connect("prepared_statements=false") }

    it "throws errors on invalid unprepared statements" do
      # Expect a valid statement to succeed.
      db.exec("insert into books (id, title) values (now(), ?)", "A title")
      # Expect an invalid statement to fail.
      expect_raises(Cassandra::DBApi::StatementError,
                    /ErrorServerSyntaxError/) do
        db.exec("do not insert into books (id, title) values (now(), ?)")
      end
    end
  end
end
