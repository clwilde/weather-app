require "test_helper"

class WeatherServiceTest < ActiveSupport::TestCase
  test "call with invalid lat/long" do
    assert_raises IOError do
      WeatherService.retrieve(190, 190)
    end
  end

  test "call with known address" do
    # Example address is 1 Infinite Loop, Cupertino, California
    latitude = 37.331669
    longitude = -122.030098

    weather = WeatherService.retrieve(latitude, longitude)
    assert_includes 0..100, weather.temperature
    assert_includes 0..100, weather.temperature_min
    assert_includes 0..100, weather.temperature_max
    assert_includes 0..100, weather.humidity
    assert_includes 900..1100, weather.pressure
    refute_empty weather.description
  end
end
