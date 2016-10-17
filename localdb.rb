require 'sqlite3'


class RecordDB
  def initialize(dbname)
    @dbname = dbname
    return if File.exist?(dbname)

    SQLite3::Database.new(dbname) do |db|
      db.execute <<-SQL
        CREATE TABLE record(
          date INTEGER,
          name TEXT,
          amount INTEGER,
          place TEXT
         )
      SQL
    end
  end

  def delete_existing( list )
    sql = 'SELECT * from record'
    keys = [:date,:name,:amount,:place]

    SQLite3::Database.new(@dbname) do |db|
      db.execute(sql) do |row|
        h = Hash[[keys,row].transpose]
        index = list.index(h)
        list.delete_at(index) if index
      end
    end
  end

  def add_records( list )
    sql = 'INSERT INTO record values(:date,:name ,:amount ,:place)'
  p list
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