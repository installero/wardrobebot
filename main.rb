require "json"
require "net/http"
require "byebug"
require "telegram/bot"
require "dotenv"

require_relative "lib/clothes_item"
require_relative "lib/wardrobe"
require_relative "lib/open_weather_map"

Dotenv.load

# Конфигурация

api_key = ENV["OPENWEATHER_API_KEY"]
spreadsheet_key = ENV["SPREADSHEET_KEY"]
city = ENV["CITY"]
telegram_bot_api_key = ENV["TELEGRAM_BOT_API_KEY"]

# Основная программа

Telegram::Bot::Client.run(telegram_bot_api_key) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Привет, #{message.from.first_name}!")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Пока, #{message.from.first_name}!")
    else
      temperature = open_weather_current_temperature(api_key, city)

      temperature_text = "По данным openweathermap.org в Москве сейчас #{temperature}°C"

      wardrobe = Wardrobe.new(spreadsheet_key)

      items = wardrobe.random_suitable_items(temperature)

      items_text = "Предлагая сегодня надеть:\n\n"
      items_text += items.map { |item| item.info }.join("\n")

      bot.api.send_message(chat_id: message.chat.id, text: temperature_text)
      bot.api.send_message(chat_id: message.chat.id, text: items_text)
    end
  end
end
