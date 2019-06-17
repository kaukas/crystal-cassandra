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
end
