class WeatherService
  require "ostruct"
  # This service retrieves weather information from the OpenWeather API.
  # It requires a valid API key to function properly.
  # API key is stored in Rails credentials as openweather_api_key.

  def initialize(latitude, longitude)
    @response = connection.get("/data/3.0/onecall", {
      appid: ENV["OPENWEATHER_API_KEY"],
      lat: latitude,
      lon: longitude,
      exclude: "minutely,hourly, alerts",
      units: "imperial"
    })

    raise IOError.new("OpenWeather response error") unless @response.status == 200

    true
  end

  def current
    @current ||= OpenStruct.new(
      temperature: @response.body["current"]["temp"],
      humidity: @response.body["current"]["humidity"],
      pressure: @response.body["current"]["pressure"],
      description: @response.body["current"]["weather"][0]["description"],
      )
  end

  def daily
    @daily ||= @response.body["daily"].map do |day|
      OpenStruct.new(
        date: Time.at(day["dt"]).strftime("%Y-%m-%d"),
        temperature_min: day["temp"]["min"],
        temperature_max: day["temp"]["max"],
        humidity: day["humidity"],
        pressure: day["pressure"],
        description: day["weather"][0]["description"],
      )
    end
  end

  private

  def connection
    connection ||= Faraday.new("https://api.openweathermap.org") do |f|
      f.request :json # encode request bodies as JSON
      f.request :retry # retry failures
      f.response :json # decode response as JSON
    end
  end
end
