def open_weather_current_temperature(api_key, city)
  base_url = "https://api.openweathermap.org/data/2.5/weather"

  units = "metric"

  url = "#{base_url}?q=#{city}&APPID=#{api_key}&units=#{units}"

  uri = URI(url)
  response = Net::HTTP.get(uri)

  data = JSON.parse(response, symbolize_names: true)

  temperature = data[:main][:temp].to_f

  return temperature
end
