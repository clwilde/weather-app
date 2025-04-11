require "test_helper"

class ForecastsControllerTest < ActionDispatch::IntegrationTest
  test "show with input form for address" do
    address = Faker::Address.full_address
    get forecasts_show_url, params: { address: address }
    assert_response :success
  end
end
