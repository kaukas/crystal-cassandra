require "../spec_helper"
require "../../src/cassandra/dbapi"
require "./aliases"
require "./custom_dbapi"

macro test_compound_scalar(col_name, type_name, raw, encoded)
  it "insert/get value #{ {{encoded}} } from table", prepared: :both do |db|
    db.exec("truncate compound_scalars")
    db.exec(
      "insert into compound_scalars (id, #{ {{col_name}} }) " \
        "values (now(), #{ {{encoded}} })"
    )
    db.query_one(
      "select #{ {{col_name}} } from compound_scalars allow filtering",
      as: typeof({{raw}})
    ).should eq({{raw}})
  end

  it "insert/get value #{ {{encoded}} } from table as nillable",
     prepared: :both do |db|
    db.exec("truncate compound_scalars")
    db.exec(
      "insert into compound_scalars (id, #{ {{col_name}} }) " \
        "values (now(), #{ {{encoded}} })"
    )
    db.query_one(
      "select #{ {{col_name}} } from compound_scalars allow filtering",
      as: typeof({{raw}}) | Nil
    ).should eq({{raw}})
  end

  it "insert/get value nil from table as nillable #{ {{type_name}} }",
     prepared: :both do |db|
    db.exec("truncate compound_scalars")
    db.exec(
      "insert into compound_scalars (id, #{ {{col_name}} }) " \
        "values (now(), NULL)"
    )
    db.query_one(
      "select #{ {{col_name}} } from compound_scalars allow filtering",
      as: typeof({{raw}}) | Nil
    ).should eq(nil)
  end

  it "insert/get value #{ {{encoded}} } from table with binding",
     prepared: :both do |db|
    db.exec("truncate compound_scalars")
    db.exec(
      "insert into compound_scalars (id, #{ {{col_name}} }) " \
        "values (now(), ?)",
      [{{raw}}]
    )
    db.query_one(
      "select #{ {{col_name}} } from compound_scalars allow filtering",
      as: typeof({{raw}})
    ).should eq({{raw}})
  end

  it "insert/get value #{ {{encoded}} } from table as nillable with binding",
     prepared: :both do |db|
    db.exec("truncate compound_scalars")
    db.exec(
      "insert into compound_scalars (id, #{ {{col_name}} }) values (now(), ?)",
      [{{raw}}]
    )
    db.query_one(
      "select #{ {{col_name}} } from compound_scalars allow filtering",
      as: typeof({{raw}}) | Nil
    ).should eq({{raw}})
  end

  it "insert/get value nil from table as nillable #{ {{type_name}} } " \
       "with binding",
     prepared: :both do |db|
    db.exec("truncate compound_scalars")
    db.exec(
      "insert into compound_scalars (id, #{ {{col_name}} }) values (now(), ?)",
      nil
    )
    db.query_one(
      "select #{ {{col_name}} } from compound_scalars allow filtering",
      as: typeof({{raw}}) | Nil
    ).should eq(nil)
  end

  it "can use read(#{typeof({{raw}})}) with DB::ResultSet",
     prepared: :both do |db|
    db.exec("truncate compound_scalars")
    db.exec(
      "insert into compound_scalars (id, #{ {{col_name}} }) " \
        "values (now(), #{ {{encoded}} })"
    )
    db.query(
      "select #{ {{col_name}} } from compound_scalars allow filtering"
    ) do |rs|
      assert_single_read rs.as(DB::ResultSet), typeof({{raw}}), {{raw}}
    end
  end

  it "can use read(#{typeof({{raw}})}?) with DB::ResultSet",
     prepared: :both do |db|
    db.exec("truncate compound_scalars")
    db.exec(
      "insert into compound_scalars (id, #{ {{col_name}} }) " \
        "values (now(), #{ {{encoded}} })"
    )
    db.query(
      "select #{ {{col_name}} } from compound_scalars allow filtering"
    ) do |rs|
      assert_single_read rs.as(DB::ResultSet), typeof({{raw}}) | Nil, {{raw}}
    end
  end

  it "can use read(#{typeof({{raw}})}?) with DB::ResultSet for nil",
     prepared: :both do |db|
    db.exec("truncate compound_scalars")
    db.exec(
      "insert into compound_scalars (id, #{ {{col_name}} }) " \
        "values (now(), NULL)"
    )
    db.query(
      "select #{ {{col_name}} } from compound_scalars allow filtering"
    ) do |rs|
      assert_single_read rs.as(DB::ResultSet), typeof({{raw}}) | Nil, nil
    end
  end
end

Cassandra::LibCass.log_set_level(Cassandra::LibCass::CassLogLevel::LogDisabled)

private def assert_single_read(rs, value_type, value)
  rs.move_next.should be_true
  rs.read(value_type).should eq(value)
  rs.move_next.should be_false
end

describe Cassandra::DBApi do
  it "supports a custom port" do
    # Expect correct port to succeed.
    DB.open("cassandra://root@127.0.0.1:9042")
    # Expect incorrect port to fail.
    expect_raises(Cassandra::DBApi::Session::ConnectError,
                  "ErrorLibNoHostsAvailable") do
      DB.open("cassandra://root@127.0.0.1:55")
    end
  end
end

# According to https://cassandra.apache.org/doc/latest/cql/types.html
PRIMITIVE_TYPES = [
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

  # Floating point
  # TODO:
  # {name: "decimal", raw: ..., encoded: "..."},
  {name: "float", raw: 42.5_f32, encoded: "42.5"},
  {name: "double", raw: 42.5_f64, encoded: "42.5"},

  # Date and time
  {name: "date",
   raw: Cassandra::DBApi::Date.new(Time.utc(2016, 2, 15)),
   encoded: Cassandra::DBApi::Date.new(Time.utc(2016, 2, 15)).days.to_s},
  # TODO: duration
  {name: "time",
   raw: Cassandra::DBApi::Time.new(Time.utc(1970, 1, 1, 4)),
   encoded: Cassandra::DBApi::Time.new(Time.utc(1970, 1, 1, 4))
            .total_nanoseconds
            .to_s},
  {name: "timestamp",
   raw: Time.utc(2016, 2, 15, 4, 20, 25),
   encoded: (Time.utc(2016, 2, 15, 4, 20, 25) - Time.unix_ms(0)).
            total_milliseconds.
            to_i64.
            to_s},

  # UUIDs
  {name: "uuid",
   raw: Cassandra::DBApi::Uuid.new("550e8400-e29b-41d4-a716-446655440000"),
   encoded: "550e8400-e29b-41d4-a716-446655440000"},
  {name: "timeuuid",
   raw: Cassandra::DBApi::TimeUuid.new("00b69180-d0e1-11e2-8b8b-0800200c9a66"),
   encoded: "00b69180-d0e1-11e2-8b8b-0800200c9a66"},

  # Specialized
  # TODO: blob
  {name: "boolean", raw: true, encoded: "true"},
  # TODO: counter, inet
]

CassandraSpecs.run do
  # Expect correct port to succeed.
  connection_string "cassandra://root@127.0.0.1/crystal_cassandra_dbapi_test"

  DBHelper.setup

  DBHelper.connect do |db|
    db.exec "drop table if exists scalars"

    simple_columns = PRIMITIVE_TYPES.map do |type|
      name = type[:name]
      name = "'#{name}'" if name.chars.any?(&.uppercase?)
      "#{type[:name]}_val #{name}"
    end
    db.exec <<-CQL
      create table scalars (
        id timeuuid primary key,
        null_val text,
        null_cond text,
        #{simple_columns.join(",\n     ")}
      )
    CQL
    db.exec "insert into scalars (id, null_val, null_cond) " \
            "values (now(), NULL, 'NULL')"
    PRIMITIVE_TYPES.each do |type|
      db.exec "insert into scalars (id, #{type[:name]}_val) " \
              "values (now(), #{type[:encoded]})"
    end

    compound_columns = (
      Array.
        product(["list", "set"], PRIMITIVE_TYPES).
        reject do |(coll_type, prim_type)|
          # Skip unsupported combinations.
          coll_type == "set" && prim_type.as(NamedTuple)[:name] == "duration"
        end.
        map do |(coll_type, prim_type)|
          coll = coll_type.as(String)
          prim = prim_type.as(NamedTuple)[:name]
          "#{coll}_#{prim} #{coll}<#{prim}>"
        end
    ) + (
      Array.
        product(PRIMITIVE_TYPES, PRIMITIVE_TYPES).
        reject do |(key_def, _)|
          # Skip unsupported combinations.
          key_def[:name] == "duration"
        end.
        map do |(key_def, val_def)|
          key = key_def[:name]
          val = val_def[:name]
          "map_#{key}_#{val} map<#{key}, #{val}>"
        end
    )
    db.exec <<-CQL
      create table compound_scalars (
        id timeuuid primary key,
        #{compound_columns.join(",\n    ")}
      )
    CQL
  end

  PRIMITIVE_TYPES.each do |type|
    sample_value(type[:raw], type[:name], type[:encoded], type_safe_value: false)
  end

  binding_syntax do |_index|
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
      #{col2.name} #{col2.sql_type}
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

  # List
  test_compound_scalar "list_ascii",
                       "list<ascii>",
                       nil,
                       "[]"
  test_compound_scalar "list_ascii",
                       "list<ascii>",
                       [Any.new("c"), Any.new("b"), Any.new("a")],
                       "['c', 'b', 'a']"
  test_compound_scalar "list_int",
                       "list<int>",
                       [Any.new(3), Any.new(2), Any.new(1)],
                       "[3, 2, 1]"

  # Set
  test_compound_scalar "set_ascii",
                       "set<ascii>",
                       nil,
                       "{}"
  test_compound_scalar "set_ascii",
                       "set<ascii>",
                       Set.new([Any.new("c"), Any.new("b"), Any.new("a")]),
                       "{'c', 'b', 'a'}"
  test_compound_scalar "set_int",
                       "set<int>",
                       Set.new([Any.new(3), Any.new(2), Any.new(1)]),
                       "{3, 2, 1}"

  # Map
  test_compound_scalar "map_ascii_ascii",
                       "map<ascii, ascii>",
                       nil,
                       "{}"
  test_compound_scalar "map_ascii_ascii",
                       "map<ascii, ascii>",
                       {Any.new("one") => Any.new("1"),
                        Any.new("two") => Any.new("2")} of Any => Any,
                       "{'one': '1', 'two': '2'}"
  test_compound_scalar "map_int_int",
                       "map<int, int>",
                       {Any.new(1) => Any.new(10),
                        Any.new(2) => Any.new(20)} of Any => Any,
                       "{1: 10, 2: 20}"

  it "does not support the affected row count", prepared: :default do |db|
    db.exec("truncate compound_scalars")
    exec_result = db.exec("insert into compound_scalars (id) values (now())")
    exec_result.rows_affected.should eq(0)
  end

  it "does not support the last inserted id", prepared: :default do |db|
    db.exec("truncate compound_scalars")
    exec_result = db.exec("insert into compound_scalars (id) values (now())")
    exec_result.last_insert_id.should eq(0)
  end
end
