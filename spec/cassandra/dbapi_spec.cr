require "spec"
require "../../src/cassandra/dbapi"
require "./custom_dbapi"

Cassandra::LibCass.log_set_level(
  Cassandra::LibCass::CassLogLevel::CassLogDisabled
)

describe Cassandra::DBApi do
  it "supports a custom port" do
    # Expect correct port to succeed.
    DB.open("cassandra://root@127.0.0.1:9042")
    # Expect incorrect port to fail.
    expect_raises(Cassandra::DBApi::ConnectError,
                  "CassErrorLibNoHostsAvailable") do
      DB.open("cassandra://root@127.0.0.1:55")
    end
  end
end

# According to https://docs.datastax.com/en/dse/6.0/cql/cql/cql_reference/refDataTypes.html
TYPES = [
  # String types
  {name: "ascii", raw: "ascii value", encoded: "'ascii value'"},
  {name: "text", raw: "text value", encoded: "'text value'"},
  {name: "varchar", raw: "varchar value", encoded: "'varchar value'"},

  # Integers
  {name: "tinyint", raw: 42_i8, encoded: "42"},
  {name: "smallint", raw: 42_i16, encoded: "42"},
  {name: "int", raw: 42_i32, encoded: "42"},
  {name: "bigint", raw: 42_000_000_000_i64, encoded: "42000000000"},
  # TODO:
  # {name: "varint", raw: 42_000_000_000_i64, encoded: "42000000000"},

  # Decimals
  # TODO:
  # {name: "decimal", raw: ..., encoded: "..."},
  {name: "float", raw: 42.5_f32, encoded: "42.5"},
  {name: "double", raw: 42.5_f64, encoded: "42.5"},

  # Date and time
  {name: "date",
   raw: Cassandra::DBApi::Date.new(Time.utc(2016, 2, 15)),
   encoded: Cassandra::DBApi::Date.new(Time.utc(2016, 2, 15)).days.to_s},
  # TODO: requires dse.
  # {name: "DateRangeType",
  #  raw: "2016-02", # Cassandra::DBApi::Date.new(Time.utc(2016, 2, 15)),
  #  encoded: "'2016-02'"}, #Cassandra::DBApi::Date.new(Time.utc(2016, 2, 15)).days.to_s},
  {name: "duration",
   raw: Cassandra::DBApi::Duration.new(0, 0, Time::Span.new(12, 30, 0)),
   encoded: "12h30m"},
  {name: "time",
   raw: Cassandra::DBApi::Time.new(Time.utc(1970, 1, 1, 4)),
   encoded: Cassandra::DBApi::Time.new(Time.utc(1970, 1, 1, 4))
            .total_nanoseconds
            .to_s},
  {name: "timestamp",
   raw: Time.utc(2016, 2, 15, 4, 20, 25),
   encoded: (Time.utc(2016, 2, 15, 4, 20, 25) - Time.epoch(0)).total_milliseconds.to_i64.to_s},
]

CassandraSpecs.run do
  # Expect correct port to succeed.
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

    columns = TYPES.map do |type|
      name = type[:name]
      name = "'#{name}'" if name.chars.any?(&.uppercase?)
      "#{type[:name]}_val #{name},"
    end
    db.exec <<-CQL
      create table scalars (
        id timeuuid primary key,
        null_val text,
        null_cond text,
        #{columns.join(",\n        ")}
      )
    CQL
    db.exec "insert into scalars (id, null_val, null_cond) " \
            "values (now(), NULL, 'NULL')"
    TYPES.each do |type|
      db.exec "insert into scalars (id, #{type[:name]}_val) " \
              "values (now(), #{type[:encoded]})"
    end
  end

  TYPES.each do |type|
    sample_value type[:raw], type[:name], type[:encoded]
  end

  binding_syntax do |index|
    "?"
  end

  select_scalar_syntax do |expr, expr_type|
    if expr == "NULL"
      val = "null_val"
      cond = "null_cond"
      expr = "'#{expr}'" unless expr == "?"
    else
      val = cond = "#{expr_type}_val"
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
end
