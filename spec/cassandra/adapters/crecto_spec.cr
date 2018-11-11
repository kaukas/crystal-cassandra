require "spec"
require "./crecto_helper"

describe "Crecto::Adapters::Cassandra" do
  DB.open "cassandra://root@127.0.0.1" do |db|
    db.exec "drop keyspace if exists crystal_cassandra_dbapi_test"
    db.exec <<-CQL
      create keyspace crystal_cassandra_dbapi_test
      with replication = { 'class': 'SimpleStrategy', 'replication_factor': 1 }
    CQL
  end

  DB.open "cassandra://root@127.0.0.1/crystal_cassandra_dbapi_test" do |db|
    db.exec "DROP TABLE IF EXISTS users"
    # db.exec <<-CQL
    #   create table users(
    #     id timeuuid PRIMARY KEY,
    #     name text,
    #     smallnum smallint,
    #     things int,
    #     stuff int,
    #     nope float,
    #     yep boolean,
    #     pageviews bigint,
    #     some_date timestamp,
    #     created_at timestamp,
    #     updated_at timestamp,
    #     unique_field text
    #   )
    # CQL
    db.exec <<-CQL
      create table users(
        id timeuuid PRIMARY KEY,
        name text,
        created_at timestamp,
        updated_at timestamp
      )
    CQL
  end

  Spec.before_each do
    Crecto::Adapters.clear_sql
  end

  it "should generate insert query" do
    Repo.insert(User.from_json(%({ "name": "chuck" })))
    check_sql do |sql|
      sql.should eq([
        "INSERT INTO users (name, things, smallnum, nope, yep, some_date, pageviews, unique_field, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
        # "SELECT * FROM users WHERE (id = LAST_INSERT_ID())",
      ])
    end
  end

  # it "should generate get query" do
  #   user = Repo.insert(User.from_json("{ \"name\":\"lucy\" }"))
  #   Crecto::Adapters.clear_sql
  #   Repo.get(User, user.instance.id)
  #   check_sql do |sql|
  #     sql.should eq(["SELECT * FROM users WHERE (id=?) LIMIT 1"])
  #   end
  # end
  #
  # it "should generate sql for query syntax" do
  #   query = Query
  #     .where(name: "fridge")
  #     .where("users.things < ?", [124])
  #     .order_by("users.name ASC")
  #     .order_by("users.things DESC")
  #     .limit(1)
  #   Repo.all(User, query)
  #   check_sql do |sql|
  #     sql.should eq(["SELECT users.* FROM users WHERE  (users.name=?) AND (users.things < ?) ORDER BY users.name ASC, users.things DESC LIMIT 1"])
  #   end
  # end
  #
  # it "should generate update queries" do
  #   changeset = Repo.insert(User.from_json(%({ "name": "linus" })))
  #   Crecto::Adapters.clear_sql
  #   changeset.instance.name = "snoopy"
  #   changeset.instance.yep = false
  #   Repo.update(changeset.instance)
  #   check_sql do |sql|
  #     sql.should eq([
  #       "UPDATE users SET name=?, things=?, smallnum=?, nope=?, yep=?, some_date=?, pageviews=?, unique_field=?, created_at=?, updated_at=?, id=? WHERE (id=?)",
  #       "SELECT * FROM users WHERE (id=?)",
  #     ])
  #   end
  # end
  #
  # it "should generate delete queries" do
  #   changeset = Repo.insert(User.from_json(%({ "name": "sally" })))
  #   Crecto::Adapters.clear_sql
  #   Repo.delete(changeset.instance)
  #   check_sql do |sql|
  #     sql.should eq(
  #       ["DELETE FROM addresses WHERE  (addresses.user_id=?)",
  #        "SELECT user_projects.project_id FROM user_projects WHERE  (user_projects.user_id=?)",
  #        "SELECT * FROM users WHERE (id=?)",
  #        "DELETE FROM users WHERE (id=?)"])
  #   end
  # end
  #
  # it "should generate IS NULL query" do
  #   quick_create_user("nullable")
  #   Crecto::Adapters.clear_sql
  #   query = Query.where(things: nil)
  #   Repo.all(User, query)
  #   check_sql do |sql|
  #     sql.should eq(["SELECT users.* FROM users WHERE  (users.things IS NULL)"])
  #   end
  # end
  #
  # it "should generates JOIN clause from string" do
  #   query = Query.join "INNER JOIN users ON users.id = posts.user_id"
  #   Repo.all(Post, query)
  #   check_sql do |sql|
  #     sql.should eq(["SELECT posts.* FROM posts INNER JOIN users ON users.id = posts.user_id"])
  #   end
  # end
end
