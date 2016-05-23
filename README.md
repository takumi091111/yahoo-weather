## Overview
Yahoo!天気のデータを取得するライブラリ
## Using
Weather.new("都道府県名","今日/明日/明後日")
```
require "./weather.rb"

hoge = Weather.new("大阪","明後日")
```
## 予報を取得
```
hoge.telop => "雨後曇"
```
## 最高気温を取得
```
hoge.maxtemp => "20℃"
```
## 最低気温を取得
```
hoge.mintemp => "15℃"
```