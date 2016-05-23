# coding: utf-8
# Yahoo!天気 RSS取得

require "./weather.rb"

# オブジェクトを作成(都道府県名,今日/明日/明後日)
test = Weather.new("茨城","明後日")
# .telop ==> 予報を返す(雨後曇など)
puts "#{test.telop}"
# .maxtemp ==> 最高気温を返す
puts "最高気温は#{test.maxtemp}"
# .maxtemp ==> 最低気温を返す
puts "最低気温は#{test.mintemp}"
# .rain? ==> 雨が降る場合 => true, 降らない場合 => false を返す
if test.rain?
    puts "降る"
else
    puts "降らない"
end
