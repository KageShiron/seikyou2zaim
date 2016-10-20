require 'pg'
require 'uri'

class RecordDB
  def initialize(dbname)
    uri = URI::parse(ENV["DATABASE_URL"] || "postgres://postgres:postgres@localhost:5432/" + dbname)
    database = (uri.path || "").split("/")[1]

    username = uri.user
    password = uri.password

    host = uri.host
    port = uri.port

    params = CGI.parse(uri.query || "")

    @con = PG::connect(:host => host,:user => username , :password => password , :dbname => database , :port => port )

=begin
      #con.exec("SELECT relname FROM pg_class WHERE relkind = 'r' AND relname = 'items';").count
    ensure
      #con.finish
=end
  end

  def delete_existing( list )
    sql = 'SELECT * from record;'
    keys = [:date,:name,:amount,:place]

    db = @con
    #SQLite3::Database.new(@dbname) do |db|
    db.exec(sql) do |rows|
      rows.each do |row|
      h = {:date => Date.parse(row["date"] || "" ) , :name => row["name"] , :amount => row["amount"].to_i,:place => row["place"] }  #Hash[[keys,row.to_a].transpose]
      index = list.index(h)
      list.delete_at(index) if index
      end
      end
    #end
  end

  def read_setting( key )
    return @con.exec( "SELECT value FROM setting WHERE key='#{key}'").to_a.first()["value"]
  end

  def add_records( list )
    sql = 'INSERT INTO record values($1,$2 ,$3 ,$4);'

    db = @con
    #SQLite3::Database.new(@dbname) do |db|
      db.transaction do
        list.each do |i|
          #i.select!{|key,val| [:date,:name,:amount,:place].include?(key) }
          db.exec(sql,[i[:date],i[:name],i[:amount],i[:place]])
        end
      end
    #end
    return list
  end

  def finish
    @con.finish
  end

  def drop_database
    @con.exec("DELETE FROM record;")
  end

end

