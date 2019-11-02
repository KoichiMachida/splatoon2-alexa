require 'open-uri'
require 'nokogiri'

url1 = 'https://splatoon.caxdb.com/schedule2.cgi'
url2 = 'https://splatoon.caxdb.com/splatoon2/coop_schedule2.cgi'

# 要素ノードは配列で帰ってくるので、結果格納用
result1 = []
result2 = []
result3 = []
result4 = []
result5 = []
result6 = []
result7 = []
result8 = []

salmon1 = []
salmon2 = []
salmon3 = []

intent "LaunchRequest" do
  charset1 = nil
  html1 = open(url1) do |f|
      charset1 = f.charset
      f.read
  end

  doc = Nokogiri::HTML.parse(html1, nil, charset1)
  # 今の時間
  doc.xpath('//body/ul/ul[1]/li[2]').each do |node|
    result1 = node.inner_text.gsub!("ガチマッチ","")
  end
  doc.xpath('//body/ul/ul[1]/ul[2]').each do |node|
    result2 = node.inner_text.strip.split.join("と")
  end

  doc.xpath('//body/ul/ul[1]/li[3]').each do |node|
    result3 = node.inner_text.gsub!("リーグマッチ","")
  end
  doc.xpath('//body/ul/ul[1]/ul[3]').each do |node|
    result4 = node.inner_text.strip.split.join("と")
  end

  # 次の時間
  doc.xpath('//body/ul/ul[2]/li[2]').each do |node|
    result5 = node.inner_text.gsub!("ガチマッチ","")
  end
  doc.xpath('//body/ul/ul[2]/ul[2]').each do |node|
    result6 = node.inner_text.strip.split.join("と")
  end

  doc.xpath('//body/ul/ul[2]/li[3]').each do |node|
    result7 = node.inner_text.gsub!("リーグマッチ","")
  end
  doc.xpath('//body/ul/ul[2]/ul[3]').each do |node|
    result8 = node.inner_text.strip.split.join("と")
  end

    ask("ただいまのガチマッチは#{result1}。ステージは#{result2}です。
    リーグマッチは#{result3}。ステージは#{result4}です。")
end

intent "NextIntent" do
    ask("次の時間のガチマッチは#{result5}。ステージは#{result6}です。
    リーグマッチは#{result7}。ステージは#{result8}です。")
end

intent "SalmonIntent" do
  # サーモンラン
  charset2 = nil
  html2 = open(url2) do |s|
      charset2 = s.charset
      s.read
  end

  doc = Nokogiri::HTML.parse(html2, nil, charset2)
  # 直近の時間
  doc.xpath('//body/ul/li[1]').each do |node|
    # salmon1 = node.inner_text.gsub!(" 0","").gsub!("/","月").gsub!(":","時").gsub!("-","から。").insert(3, "日").insert(15, "日")
    salmon1 = node.inner_text.gsub("/","月").gsub("-","から。").insert(5, "日").insert(-7, "日")
  end
  # ステージ
  doc.xpath('//body/ul/ul[1]/ul/li').each do |node|
    salmon2 = node.inner_text
  end
  # 支給ブキ
  doc.xpath('//body/ul/ul[2]/ul').each do |node|
    salmon3 = node.inner_text.strip.split.join("。")
  end
    ask("直近のサーモンランのシフトは。#{salmon1}です。ステージは#{salmon2}。
      支給武器は#{salmon3}です。")
end

intent "AMAZON.CancelIntent" do
    tell("マンメンミ")
end

intent "AMAZON.StopIntent" do
    tell("マンメンミ")
end
