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

  DB.open "cassandra://root@127.0.0.1/crystal_cassandra_dbapi_test" do |db|
    db.exec "drop table if exists scalars"
    db.exec <<-CQL
      create table scalars (
        id timeuuid primary key,
        null_val text,
        null_cond text,
        text_val text,
        int_val int,
        bigint_val bigint
      )
    CQL
    db.exec "insert into scalars (id, null_val, null_cond) values (now(), NULL, 'NULL')"
    db.exec "insert into scalars (id, text_val) values (now(), 'text value')"
    db.exec "insert into scalars (id, int_val) values (now(), 42)"
    db.exec "insert into scalars (id, bigint_val) values (now(), 42000000000)"
  end

  sample_value "text value", "text", "'text value'"
  sample_value "text value", "varchar", "'text value'"
  sample_value 42_i32, "int", "42"
  sample_value 42_000_000_000_i64, "bigint", "42000000000"

  binding_syntax do |index|
    "?"
  end

  select_scalar_syntax do |expr, expr_type|
    if expr == "NULL"
      val = "null_val"
      cond = "null_cond"
      expr = "'#{expr}'" unless expr == "?"
    else
      val = cond = case expr_type
                   when "int"
                     "int_val"
                   when "bigint"
                     "bigint_val"
                   else
                     "text_val"
                   end
    end

    "select #{val} from scalars where #{cond} = #{expr} allow filtering"
  end

  select_1column_syntax do |table_name, col1|
    "select #{col1.name} from #{table_name}"
  end

  select_2columns_syntax do |table_name, col1, col2|
    "select #{col1.name}, #{col2.name} from #{table_name}"
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
