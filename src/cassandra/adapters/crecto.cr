require "../dbapi"
require "crecto"
require "crecto/adapters/base_adapter"

module Crecto::Adapters
  module Cassandra
    extend BaseAdapter

    alias Any = ::Cassandra::DBApi::Any

    private def self.insert(conn, changeset)
      instance = changeset.instance
      if instance.pkey_value.nil?
        instance.update_primary_key(::Cassandra::DBApi::TimeUuid.new)
      end

      fields_values = instance_fields_and_values(instance)

      q = String.build do |builder|
        builder <<
        "INSERT INTO " << instance.class.table_name <<
        " (" << fields_values[:fields].join(", ") << ")" <<
        " VALUES" <<
        " ("
        fields_values[:values].size.times do
          builder << "?, "
        end
        builder.back(2)
        # builder << ") RETURNING *"
        builder << ")"
      end

      p q
      p fields_values[:values]
      execute(conn, position_args(q), fields_values[:values])
    end

    private def self.update_begin(builder, table_name, fields_values)
      builder << "UPDATE " << table_name << " SET "
      fields_values[:fields].each do |field_value|
        builder << field_value << "=?, "
      end
      builder.back(2)
    end

    private def self.update(conn, changeset)
      fields_values = instance_fields_and_values(changeset.instance)

      q = String.build do |builder|
        update_begin(builder, changeset.instance.class.table_name, fields_values)
        builder << " WHERE (" << changeset.instance.class.primary_key_field << "=?)"
        builder << " RETURNING *"
      end

      execute(conn, position_args(q), fields_values[:values] + [changeset.instance.pkey_value])
    end

    private def self.instance_fields_and_values(query_hash : Hash)
      values = query_hash.values.map do |x|
        if x.is_a?(JSON::Any)
          Any.new(x)
        elsif x.is_a?(Array)
          Any.new(x.map { |item| Any.new(item) })
        else
          Any.new(x)
        end
      end
      {fields: query_hash.keys, values: values}
    end

    private def self.position_args(query_string : String)
      query_string
    end
  end
end

class Crecto::Repo::Config
  @adapter : Crecto::Adapters::BaseAdapter

  def adapter : Crecto::Adapters::BaseAdapter
    @adapter
  end

  def adapter=(@adapter)
  end

  private def set_url_protocol(io)
    if adapter == Crecto::Adapters::Postgres
      io << "postgres://"
    elsif adapter == Crecto::Adapters::Mysql
      io << "mysql://"
    elsif adapter == Crecto::Adapters::SQLite3
      io << "sqlite3://"
    elsif adapter == Crecto::Adapters::Cassandra
      io << "cassandra://"
    end
  end
end

module Cassandra::DBApi
  class ValueBinder
    private def do_bind(val : JSON::Any)
      do_bind(Any.new(val))
    end
  end

  struct TimeUuid
    def initialize(json : JSON::PullParser)
      p json
      raise "very bad"
      LibCass.uuid_gen_random(GENERATOR, out @cass_uuid)
    end
  end
end
