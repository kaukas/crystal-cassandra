# Crystal DB API for Cassandra

A Crystal wrapper around the [DataStax C/C++
Driver](https://docs.datastax.com/en/developer/cpp-driver/2.10/). It conforms to
the [crystal-db](https://github.com/crystal-lang/crystal-db) API.

## Status

This is a personal project to create something meaningful while learning
Crystal. There are no guarantees about future development, maintenance, or
support. That said, if you need to use Crystal to query Cassandra this library
could be a good starting point. YMMV.

## Installation

Please make sure you have [installed the DataStax C/C++
Driver](https://datastax.github.io/cpp-driver/topics/building/). You can use
"development" packages if they are available or build from source.

Then add this to your application's `shard.yml`:

```yaml
dependencies:
  cassandra:
    github: kaukas/crystal-cassandra
```

## Documentation

The [latest Crystal Cassandra API documentation can be found
here](https://kaukas.github.io/crystal-cassandra/latest/).

## Usage

From the [basic
example](https://github.com/kaukas/crystal-cassandra/blob/master/examples/basic.cr):

```crystal
require "cassandra/dbapi"

DB.open("cassandra://127.0.0.1/test") do |db|
  db.exec(<<-CQL)
    create table posts (
      id timeuuid primary key,
      title text,
      body text,
      created_at timestamp
    )
  CQL
  db.exec("insert into posts (id, title, body, created_at) values (now(), ?, ?, ?)",
          "Hello World",
          "Hello, World. I have a story to tell.",
          Time.now)
  db.query("select title, body, created_at from posts") do |rs|
    rs.each do
      title = rs.read(String)
      body = rs.read(String)
      created_at = rs.read(Time)
      puts title
      puts "(#{created_at})"
      puts body
    end
  end
end
```

Please refer to [crystal-db](https://github.com/crystal-lang/crystal-db) for
further usage instructions.

## Types

`crystal-cassandra` supports [all the
`DB::Any`](https://crystal-lang.github.io/crystal-db/api/0.5.0/DB/Any.html)
primitive types plus `Int8` and `Int16` and some additional value types:

- `date` maps to `Cassandra::DBApi::Date`
- `time` maps to `Cassandra::DBApi::Time`
- `uuid` maps to `Cassandra::DBApi::Uuid`
- `timeuuid` maps to `Cassandra::DBApi::TimeUuid`

Some of the collection types are also supported:

- `list` maps to `Array`
- `set` maps to `Set`
- `map` maps to `Hash`

### Casting

Cassandra supports nested collection types (lists, sets, maps, etc.). Since
Crystal [deprecated recursive
aliases](https://github.com/crystal-lang/crystal/issues/5155) they can be
represented with recursive structs. `crystal-cassandra` has
`Cassandra::DBApi::Any` which performs a similar function to
[`JSON::Any`](https://crystal-lang.org/api/latest/JSON/Any.html). You can pass
collection parameters to queries wrapped with `Cassandra::DBApi::Any` (taken
from the [collections
example](https://github.com/kaukas/crystal-cassandra/blob/master/examples/collections.cr)):

```crystal
alias Any = Cassandra::DBApi::Any

# Assuming `authors` is `list<text>`
db.exec("insert into posts (id, authors) values (now(), ?)",
        Any.new([Any.new("John Doe"), Any.new("Ben Roe")]))

db.query("select authors from posts") do |rs|
  rs.each do
    authors = rs.read(Array(Any))
    puts "Authors: #{authors.map { |author| author.as_s }.join(", ")}"
  end
end
```

You could do the same for the primitive values as well:

```crystal
db.exec("insert into posts (id, title) values (now(), ?)",
        Any.new("Hello World"))

db.query("select title from posts") do |rs|
  rs.each do
    title = rs.read(Any)
    puts title.as_s
  end
end
```

but shortcuts are defined for them so `Any` can be skipped (see the [basic
example](https://github.com/kaukas/crystal-cassandra/blob/master/examples/basic.cr)).

## Development

Install the C/C++ Driver. The `Makefile` commands work on MacOS:

```bash
make build-cppdriver
```

Start a Docker container with an instance of Cassandra:

```bash
make start-cassandra
```

Run the tests:

```bash
crystal spec
```

Stop Cassandra when finished:

```bash
make stop-cassandra
```

## Contributing

1. Fork it (<https://github.com/kaukas/crystal-cassandra/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [kaukas](https://github.com/kaukas) Linas Juškevičius - creator, maintainer
