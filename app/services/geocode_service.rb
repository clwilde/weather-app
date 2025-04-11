class GeocodeService
  require "ostruct"

  def self.retrieve(address)
    data = get_data(address)
    geocode = build_geocode(data)
  end

  private

  def self.build_geocode(data)
    OpenStruct.new(
      latitude: data["lat"],
      longitude: data["lon"],
      country_code: data["country_code"],
      postal_code: data["postcode"]
    )
  end

  def self.check_data(data)
    raise IOError.new "Geocoder data error" unless data
    raise IOError.new "Geocoder latitude is missing" unless data["lat"]
    raise IOError.new "Geocoder longitude is missing" unless data["lon"]
    raise IOError.new "Geocoder country code is missing" unless data["country_code"]
    raise IOError.new "Geocoder postal code is missing" unless data["postcode"]

    data
  end

  def self.get_data(address)
    response = Geocoder.search(address)
    raise IOError.new "Geocoder error" if response.nil?
    raise IOError.new "Response empty: #{response}" if response.empty?

    check_data(response.first.data["properties"])
  end
end
