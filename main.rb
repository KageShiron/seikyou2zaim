#! ruby -Ku
# -*- mode:ruby; coding:utf-8 -*-

require "./scraping.rb"
require "./zaim.rb"
require "./localdb"

p "open local DB"
db = RecordDB::new("seikyo")

p "start scraping..."
records = get_record_from_coop(db.read_setting('SEIKYO_ID'),db.read_setting('SEIKYO_PASS'))

p "delete existing records"
db.delete_existing( records )
p records

p "start send to Zaim"
za = Zaim::new(db.read_setting('CONSUMER_KEY'),db.read_setting('CONSUMER_SECRET'),db.read_setting('ACCESS_TOKEN'),db.read_setting('ACCESS_SECRET'))
records.each do |r|
  p r
  r[:mapping] = 1
  r[:category_id] = 101
  r[:genre_id] = 10104
  za.create_payment(r)
end

db.add_records( records )