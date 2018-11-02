require "../../src/cassandra/dbapi"

DB.open("cassandra://root@127.0.0.1") do |db|
  db.exec("drop keyspace if exists crystal_cassandra_dbapi_test")
  db.exec(<<-CQL)
    create keyspace crystal_cassandra_dbapi_test
    with replication = { 'class': 'SimpleStrategy', 'replication_factor': 1 }
  CQL
end

alias Any = Cassandra::DBApi::Any

DB.open("cassandra://127.0.0.1/crystal_cassandra_dbapi_test") do |db|
  db.exec(<<-CQL)
    create table posts (
      id timeuuid primary key,
      authors list<text>,
      tags set<text>,
      mentions map<text, int>
    )
  CQL
  db.exec("insert into posts (id, authors, tags, mentions) " \
            "values (now(), ?, ?, ?)",
          Any.new([Any.new("John Doe"), Any.new("Ben Roe")]),
          Any.new(Set.new([Any.new("web"), Any.new("crystal")])),
          Any.new({ Any.new("facebook") => Any.new(25),
                    Any.new("twitter") => Any.new(37) }))
  db.query("select authors, tags, mentions from posts") do |rs|
    rs.each do
      authors = rs.read(Array(Any))
      tags = rs.read(Set(Any))
      mentions = rs.read(Hash(Any, Any))
      puts "Authors: #{authors.map { |author| author.as_s }.join(", ")}"
      puts "Tags: #{tags.map { |tag| tag.as_s }.join(" ")}"
      puts "Mentions: #{mentions.map { |media, count| "#{count.as_i32} on #{media.as_s}" }.join(", ")}"
    end
  end
end
