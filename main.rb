require "json"
require "net/http"
require "byebug"

require_relative "lib/clothes_item"
require_relative "lib/wardrobe"
require_relative "lib/open_weather_map"

# Конфигурация

api_key = "e809fbd81e2a508842b45ad0a5c8bbc9"
spreadsheet_key = "1bPT458nCSWahOXu6FcRmv3ASWC1Yl0UuyiTlTRCBUAI"
city = "Moscow"

# Основная программа

temperature = open_weather_current_temperature

puts "По данным openweathermap.org в Москве сейчас #{temperature}°C"

wardrobe = Wardrobe.new(spreadsheet_key)

items = wardrobe.random_suitable_items(temperature)

items.each do |item|
  puts item.info
end
