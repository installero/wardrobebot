require "json"
require "net/http"
require "byebug"
require "telegram/bot"

require_relative "lib/clothes_item"
require_relative "lib/wardrobe"
require_relative "lib/open_weather_map"

# Конфигурация

api_key = "e809fbd81e2a508842b45ad0a5c8bbc9"
spreadsheet_key = "1bPT458nCSWahOXu6FcRmv3ASWC1Yl0UuyiTlTRCBUAI"
city = "Moscow"
telegram_bot_api_key =
  "650565763:AAHX_0_8l3TFgfRr1UnoOOFTKOPlVEb3ekE"

# Основная программа

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Привет, #{message.from.first_name}!")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Пока, #{message.from.first_name}!")
    else
      temperature = open_weather_current_temperature

      temperature_text = "По данным openweathermap.org в Москве сейчас #{temperature}°C"

      wardrobe = Wardrobe.new(spreadsheet_key)

      items = wardrobe.random_suitable_items(temperature)

      items_text = "Предлагая сегодня надеть:\n\n"
      items_text += items.map { |item| "#{item.info}\n" }

      bot.api.send_message(chat_id: message.chat.id, text: temperature_text)
      bot.api.send_message(chat_id: message.chat.id, text: items_text)
    end
  end
end
