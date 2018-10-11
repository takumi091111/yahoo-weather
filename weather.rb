require 'date'
require 'rss'
require 'json'

class Weather
    BASE_URL = 'https://rss-weather.yahoo.co.jp/rss/days'.freeze
    DATE_TABLE = {
      :今日 => Date.today,
      :明日 => Date.today + 1,
      :明後日 => Date.today + 2
    }.freeze

    def initialize(location_str, date_str)
      # 都道府県と県庁所在地IDの対応表を読み込む
      location_list = get_location_list
      # データ取得
      location_id = location_list[location_str.to_sym]
      date = DATE_TABLE[date_str.to_sym]
      data = get_data(location_id, date)
      @telop = data[:telop]
      @maxtemp = data[:maxtemp].to_i
      @mintemp = data[:mintemp].to_i
    end

    public

    attr_reader :telop, :maxtemp, :mintemp

    def rain?
      @telop =~ /雨/ ? true : false
    end

    private

    def get_location_list
      # 都道府県と県庁所在地IDの対応表を読み込んで返す
      json = File.read('location.json')
      location_list = JSON.parse(json, {:symbolize_names => true})
      return location_list.inject(&:merge)
    end

    def get_data(location_id, date)
      # 指定したIDのデータを取得
      rss = RSS::Parser.parse("#{BASE_URL}/#{location_id}.xml")
      # 指定した日付でフィルタリング
      data = rss.items.find{|item| item.title =~ /#{date.day}日/}
      # 予報, 最高温度, 最低温度をハッシュで返す
      data.title.match(/【.*】\s(.*)\s-\s(.*)℃\/(.*)℃\s-\s.*/)
      return {
        :telop => Regexp.last_match(1),
        :maxtemp => Regexp.last_match(2),
        :mintemp => Regexp.last_match(3)
      }
    end
end
