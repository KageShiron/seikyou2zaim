#! ruby -Ku
# -*- mode:ruby; coding:utf-8 -*-

require "nokogiri"
require 'mechanize'

Encoding.default_external = "utf-8"

def get_record_from_coop
  agent = Mechanize.new
  agent.user_agent_alias = "Windows Chrome"
  agent.get("https://mp.seikyou.jp/mypage/Static.init.do") do |page|
    res = page.form_with(:name => 'loginForm' ) do |form|
      val = File.open("pass.txt","r:utf-8").readlines()
      form.field_with(:name => "loginId").value = val[0].strip
      form.field_with(:name => "password").value = val[1].strip
    end.submit

    if res.title != "トップページ - 大学生協マイページ" then
      p "ERROR"
      exit
    end
    html = agent.post("https://mp.seikyou.jp/mypage/Menu.change.do?pageNm=ALL_HISTORY",
                      { "id" => "ALL_HISTORY" , "messageInitDirectionKbn" => "" , "messageInfoId" => "" }).content
    c = Nokogiri::HTML(html)

    trs = c.css("#contents_wrapper form[name=AllHistoryForm] input[name=rirekiDate]+table tr:not(:first)")
    items = []
    trs.each do |tr|
      break if tr.element_children[0].content.strip == ""
      item = { "date" => Date.parse(tr.element_children[0].content.strip),
               "place" => tr.element_children[1].content.strip,
               "name" => tr.element_children[2].content.strip,
               "amount" => tr.element_children[4].content.strip.to_i
      }
      items.push(item)
    end
    p items
    items
  end
end
