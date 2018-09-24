require "date"
require "rss"

class Weather
    def initialize(location_str, date_str)
        url = "https://rss-weather.yahoo.co.jp/rss/days/"
        date = DateTime.now
        # 日付を設定
        case date_str
        when /今日/ then date += 0
        when /明日/ then date += 1
        when /明後日/ then date += 2
        end
        # リストファイルの位置を調べる
        if FileTest.exists?("list.txt")
            list = "list.txt"
        else
            list = "yahoo-weather/list.txt"
        end
        # 場所を元にRSSのリンクを取得
        IO.foreach(list, encoding: "utf-8") do |line|
            if line =~ /#{location_str}:(.*)$/
                url = "#{url}#{Regexp.last_match(1)}.xml"
            end
        end
        rss = RSS::Parser.parse(url)
        rss.items.each do |item|
            # 条件を満たさなければ、ループ脱出
            next unless item.title =~ /#{date.day}日/
            next unless md = item.title.match(/【.*】\s(.*)\s-\s(.*)\/(.*)\s-\s.*/)
            @telop = Regexp.last_match(1)
            @maxtemp = Regexp.last_match(2)
            @mintemp = Regexp.last_match(3)
        end
    end

    # def hoge {return hoge}と同じ意味
    attr_reader :telop, :maxtemp, :mintemp

    def rain?
        @telop =~ /雨/ ? true : false
    end
end
