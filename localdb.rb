require 'sqlite3'


class RecordDB
  def initialize(dbname)
    @dbname = dbname
    return if File.exist?(dbname)

    SQLite3::Database.new(dbname) do |db|
      db.execute <<-SQL
        CREATE TABLE record(
          date INTEGER
          name TEXT
          amount INTEGER
          place TEXT
         )
      SQL
    end
  end

  def get_diff( list )
    sql = 'SELECT * from record'
    keys = [:date,:name,:amount,:place]

    SQLite3::Database.new(@dbname) do |db|
      db.execute(sql) do |row|
        h = Hash[[keys,row].transpose]
        list.reject! {|i| i = h }
      end
    end
    return list
  end

  def add_records( list )
    sql = 'INSERT INTO record values(:date,:name ,:amount ,:place)'

    SQLite3::Database.new(@dbname) do |db|
      db.transaction do
        list.each do |i|
          db.execute(sql,i)
        end
      end
    end
    return list
  end

end