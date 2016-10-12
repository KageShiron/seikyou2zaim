#! ruby -Ku
# -*- mode:ruby; coding:utf-8 -*-

require "./scraping.rb"
require "./zaim.rb"

records = get_record_from_coop

za = Zaim::new
records.each do |r|
  p r
  r["mapping"] = 1
  r["category_id"] = 101
  r["genre_id"] = 10104
  za.create_payment(r)
end