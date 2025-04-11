class WeatherService
  require "ostruct"
  # This service retrieves weather information from the OpenWeather API.
  # It requires a valid API key to function properly.
  # API key is stored in Rails credentials as openweather_api_key.

  def self.retrieve(latitude, longitude)
    response = connection.get("/data/2.5/weather", {
      appid: ENV["OPENWEATHER_API_KEY"],
      lat: latitude,
      lon: longitude,
      units: "imperial"
    })

    body = check_results(response.body)
    weather = build_weather_object(body)
  end

  private

  def self.build_weather_object(body)
    OpenStruct.new(
      temperature: body["main"]["temp"],
      temperature_min: body["main"]["temp_min"],
      temperature_max: body["main"]["temp_max"],
      humidity: body["main"]["humidity"],
      pressure: body["main"]["pressure"],
      description: body["weather"][0]["description"],
    )
  end

  def self.check_results(body)
    raise IOError.new("OpenWeather response failed") unless body
    raise IOError.new("OpenWeather main section is missing") unless body["main"]
    raise IOError.new("OpenWeather temperature is missing") unless body["main"]["temp"]
    raise IOError.new("OpenWeather temperature minimum is missing") unless body["main"]["temp_min"]
    raise IOError.new("OpenWeather temperature maximum is missing") unless body["main"]["temp_max"]
    raise IOError.new("OpenWeather weather section is missing") unless body["weather"]
    raise IOError.new("OpenWeather weather section is empty") unless body["weather"].length > 0
    raise IOError.new("OpenWeather weather description is missing") unless body["weather"][0]["description"]

    body
  end

  def self.connection
    connection ||= Faraday.new("https://api.openweathermap.org") do |f|
      f.request :json # encode request bodies as JSON
      f.request :retry # retry failures
      f.response :json # decode response as JSON
    end
  end
end
