require "spec"
require "../../src/cassandra/dbapi"
require "./custom_dbapi"

CassandraSpecs.run do
  connection_string "cassandra://root@127.0.0.1/crystal_cassandra_dbapi_test"

  DB.open "cassandra://root@127.0.0.1" do |db|
    db.exec "drop keyspace if exists crystal_cassandra_dbapi_test"
    db.exec <<-CQL
      create keyspace crystal_cassandra_dbapi_test
      with replication = { 'class': 'SimpleStrategy', 'replication_factor': 1 }
    CQL
  end

  sample_value "text", "text", "'text'"
  # sample_value "varchar", "varchar", "'varchar'"
  sample_value 42_i32, "int", "42"
  sample_value 42_000_000_000_i64, "bigint", "42000000000"

  binding_syntax do |index|
    "?"
  end

  drop_table_if_exists_syntax do |table_name|
    "drop table if exists #{table_name}"
  end

  create_table_1column_syntax do |table_name, col1|
    <<-CQL
    create table #{table_name} (
      id timeuuid primary key,
      #{col1.name} #{col1.sql_type}
    )
    CQL
  end

  create_table_2columns_syntax do |table_name, col1, col2|
    <<-CQL
    create table #{table_name} (
      id timeuuid primary key,
      #{col1.name} #{col1.sql_type},
      #{col2.name} #{col2.sql_type},
    )
    CQL
  end

  insert_1column_syntax do |table_name, col1, expr1|
    "insert into #{table_name} (id, #{col1.name}) values (now(), #{expr1})"
  end

  insert_2columns_syntax do |table_name, col1, expr1, col2, expr2|
    <<-CQL
    insert into #{table_name} (id, #{col1.name}, #{col2.name})
    values (now(), #{expr1}, #{expr2})
    CQL
  end

  select_1column_syntax do |table_name, col1|
    "select #{col1.name} from #{table_name}"
  end

  select_2columns_syntax do |table_name, col1, col2|
    "select #{col1.name}, #{col2.name} from #{table_name}"
  end

  # select_scalar_syntax do |expression|
  #   r = "select value from dual where cond = '#{expression}' allow filtering"
  #   puts r.inspect
  #   r
  # end

      # db.exec <<-CQL
      #   create table crystal_cassandra_dbapi_test.dual (
      #     id timeuuid primary key,
      #     value varchar,
      #     cond varchar
      #   )
      # CQL
      # db.exec <<-CQL
      #   insert into crystal_cassandra_dbapi_test.dual ("id", "value", "cond")
      #   values (now(), NULL, 'NULL')
      # CQL
end
