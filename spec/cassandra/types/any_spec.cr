require "spectator"
require "../aliases"
require "../../../src/cassandra/dbapi"

macro test_primitive(type_name,
                     as_type,
                     raw,
                     another_raw,
                     raw_of_another_type)
  it "wraps a value of type {{ type_name }}" do
    expect(Any.new({{ raw }}).raw).to eq({{ raw }})
  end

  it "can be converted to {{ type_name }}" do
    expect(Any.new({{ raw }}).{{ as_type }}).to eq({{ raw }})
    expect(Any.new({{ raw }}).{{ as_type }}?).to eq({{ raw }})
  end

  it "fails when different type value is converted to {{ type_name }}" do
    expect_raises(TypeCastError) do
      Any.new({{ raw_of_another_type }}).{{ as_type }}
    end
  end

  it "returns nil when different type value is converted to {{ type_name }}" do
    expect(Any.new({{ raw_of_another_type }}).{{ as_type }}?).to eq(nil)
  end

  it "compares raw values" do
    expect(Any.new({{ raw }}) == Any.new({{ raw }})).to eq(true)
    expect(Any.new({{ raw }}) == {{ another_raw }}).to eq(false)
    expect(Any.new({{ raw }}) == {{ raw }}).to eq(true)
  end
end

Spectator.describe Any do
  it "wraps a value of type Nil" do
    expect(Any.new(nil).raw).to eq(nil)
  end

  it "can be converted to Nil" do
    expect(Any.new(nil).as_nil).to eq(nil)
  end

  it "fails when different type value is converted to Nil" do
    expect_raises(TypeCastError) do
      Any.new(42_i64).as_nil
    end
  end

  it "compares raw values" do
    expect(Any.new(nil) == Any.new(nil)).to eq(true)
    expect(Any.new(nil) == nil).to eq(true)
  end

  let(now) { ::Time.local }

  test_primitive(Bool, as_bool, false, true, 42_i64)
  test_primitive(Int8, as_i8, 42_i8, 43_i8, 42_i64)
  test_primitive(Int16, as_i16, 42_i16, 43_i16, 42_i64)
  test_primitive(Int32, as_i32, 42_i32, 43_i32, 42_i64)
  test_primitive(Int64, as_i64, 42_i64, 43_i64, 42_i32)
  test_primitive(Float32, as_f32, 42_f32, 43_f32, 42_f64)
  test_primitive(Float64, as_f64, 42_f64, 43_f64, 42_f32)
  test_primitive(String, as_s, "word", "letter", 42_i64)
  test_primitive(Bytes, as_bytes, "word".to_slice, "letter".to_slice, 42_i64)
  test_primitive(::Time, as_timestamp, now, now + 1.day, 42_i64)
  test_primitive(
    Cassandra::DBApi::Date,
    as_date,
    Cassandra::DBApi::Date.new(now),
    Cassandra::DBApi::Date.new(now + 1.day),
    42_i64
  )
  test_primitive(
    Cassandra::DBApi::Time,
    as_time,
    Cassandra::DBApi::Time.new(now),
    Cassandra::DBApi::Time.new(now + 1.day),
    42_i64
  )
  test_primitive(
    Cassandra::DBApi::Uuid,
    as_uuid,
    Cassandra::DBApi::Uuid.new("550e8400-e29b-41d4-a716-446655440000"),
    Cassandra::DBApi::Uuid.new("550e8400-e29b-41d4-a716-446655440999"),
    42_i64
  )
  test_primitive(
    Cassandra::DBApi::TimeUuid,
    as_timeuuid,
    Cassandra::DBApi::TimeUuid.new("00b69180-d0e1-11e2-8b8b-0800200c9a66"),
    Cassandra::DBApi::TimeUuid.new("00b69180-d0e1-11e2-8b8b-0800200c9a99"),
    42_i64
  )
  test_primitive(Array, as_a, [Any.new(1)], [Any.new(2)], 42_i64)
  test_primitive(Set, as_set, [Any.new(1)].to_set, [Any.new(2)].to_set, 42_i64)
  test_primitive(
    Hash,
    as_h,
    { Any.new(1) => Any.new(1) },
    { Any.new(1) => Any.new(2) },
    42_i64
  )
end
