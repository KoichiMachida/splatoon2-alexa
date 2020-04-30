require 'open-uri'
require 'nokogiri'

# 取得元
url1 = 'https://splatoon.caxdb.com/schedule2.cgi'
url2 = 'https://splatoon.caxdb.com/splatoon2/coop_schedule2.cgi'

# スキル起動時の挙動
intent "LaunchRequest" do
  charset1 = nil
  html1 = open(url1) do |f|
    charset1 = f.charset
    f.read
  end

  doc = Nokogiri::HTML.parse(html1, nil, charset1)

  # 今の時間
  result = doc.xpath('//body/ul/ul[1]/li[2]').text.gsub("ガチマッチ",""),
           doc.xpath('//body/ul/ul[1]/ul[2]').text.split.join("と"),
           doc.xpath('//body/ul/ul[1]/li[3]').text.gsub("リーグマッチ",""),
           doc.xpath('//body/ul/ul[1]/ul[3]').text.split.join("と"),
  # 次の時間
           doc.xpath('//body/ul/ul[2]/li[2]').text.gsub("ガチマッチ",""),
           doc.xpath('//body/ul/ul[2]/ul[2]').text.split.join("と"),
           doc.xpath('//body/ul/ul[2]/li[3]').text.gsub("リーグマッチ",""),
           doc.xpath('//body/ul/ul[2]/ul[3]').text.split.join("と")

  ask("ただいまのガチマッチは#{result[0]}。ステージは#{result[1]}です。リーグマッチは#{result[2]}。ステージは#{result[3]}です。")
end

# インテント遷移後の挙動
intent "NextIntent" do
  ask("次の時間のガチマッチは#{result[4]}。ステージは#{result[5]}です。リーグマッチは#{result[6]}。ステージは#{result[7]}です。")
end

# インテント遷移後の挙動
intent "SalmonIntent" do
  # サーモンラン
  charset2 = nil
  html2 = open(url2) do |s|
    charset2 = s.charset
    s.read
  end

  doc = Nokogiri::HTML.parse(html2, nil, charset2)
  salmon = doc.xpath('//body/ul/li[1]').text.gsub(/\/|-/, "/" => "月", "-" => "から。").insert(5, "日").insert(-7, "日"), # 直近の時間
           doc.xpath('//body/ul/ul[1]/ul/li').text, # ステージ
           doc.xpath('//body/ul/ul[2]/ul').text.split.join("。") # 支給ブキ

  ask("直近のサーモンランのシフトは。#{salmon[0]}です。ステージは#{salmon[1]}。支給武器は#{salmon[2]}です。")
end

# スキル終了時の挙動
intent "AMAZON.CancelIntent" do
    tell("マンメンミ")
end

intent "AMAZON.StopIntent" do
    tell("マンメンミ")
end
