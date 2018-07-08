require "db"
require "db/spec"

private def assert_single_read(rs, value_type, value)
  rs.move_next.should be_true
  rs.read(value_type).should eq(value)
  rs.move_next.should be_false
end

class CassandraSpecs < DB::DriverSpecs(DB::Any)
  def include_shared_specs
    it "gets column count", prepared: :both do |db|
      db.exec sql_create_table_person
      db.query "select * from person" do |rs|
        # An extra id column is present.
        rs.column_count.should eq(3)
      end
    end

    it "gets column name", prepared: :both do |db|
      db.exec sql_create_table_person

      db.query "select name, age from person" do |rs|
        rs.column_name(0).should eq("name")
        rs.column_name(1).should eq("age")
      end
    end

    it "gets many rows from table" do |db|
      db.exec sql_create_table_person
      db.exec sql_insert_person, "foo", 10
      db.exec sql_insert_person, "bar", 20
      db.exec sql_insert_person, "baz", 30

      names = [] of String
      ages = [] of Int32
      db.query sql_select_person do |rs|
        rs.each do
          names << rs.read(String)
          ages << rs.read(Int32)
        end
      end
      names.sort.should eq(["bar", "baz", "foo"])
      ages.sort.should eq([10, 20, 30])
    end

    # describe "transactions" do
    # it "transactions: can read inside transaction and rollback after" do |db|
    #   db.exec sql_create_table_person
    #   db.transaction do |tx|
    #     tx.connection.scalar(sql_select_count_person).should eq(0)
    #     tx.connection.exec sql_insert_person, "John Doe", 10
    #     tx.connection.scalar(sql_select_count_person).should eq(1)
    #     tx.rollback
    #   end
    #   db.scalar(sql_select_count_person).should eq(0)
    # end
    #
    # it "transactions: can read inside transaction or after commit" do |db|
    #   db.exec sql_create_table_person
    #   db.transaction do |tx|
    #     tx.connection.scalar(sql_select_count_person).should eq(0)
    #     tx.connection.exec sql_insert_person, "John Doe", 10
    #     tx.connection.scalar(sql_select_count_person).should eq(1)
    #     # using other connection
    #     db.scalar(sql_select_count_person).should eq(0)
    #   end
    #   db.scalar("select count(*) from person").should eq(1)
    # end
    # end

    # describe "nested transactions" do
    # it "nested transactions: can read inside transaction and rollback after" do |db|
    #   db.exec sql_create_table_person
    #   db.transaction do |tx_0|
    #     tx_0.connection.scalar(sql_select_count_person).should eq(0)
    #     tx_0.connection.exec sql_insert_person, "John Doe", 10
    #     tx_0.transaction do |tx_1|
    #       tx_1.connection.exec sql_insert_person, "Sarah", 11
    #       tx_1.connection.scalar(sql_select_count_person).should eq(2)
    #       tx_1.transaction do |tx_2|
    #         tx_2.connection.exec sql_insert_person, "Jimmy", 12
    #         tx_2.connection.scalar(sql_select_count_person).should eq(3)
    #         tx_2.rollback
    #       end
    #     end
    #     tx_0.connection.scalar(sql_select_count_person).should eq(2)
    #     tx_0.rollback
    #   end
    #   db.scalar(sql_select_count_person).should eq(0)
    # end
  end
end
