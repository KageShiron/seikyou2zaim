#! ruby -Ku
# -*- mode:ruby; coding:utf-8 -*-

require "./scraping.rb"
require "./zaim.rb"
require "./localdb"

p "open local DB"
db = RecordDB::new("records.db")

p "start scraping..."
records = get_record_from_coop

p "delete existing records"
db.delete_existing( records )
p records

p "start send to Zaim"
za = Zaim::new
records.each do |r|
  p r
  da = r[:date]
  r[:date] = Time.at(r[:date]).strftime("%Y-%m-%d")
  r[:mapping] = 1
  r[:category_id] = 101
  r[:genre_id] = 10104
  za.create_payment(r)
  r[:date] = da
end

db.add_records( records )