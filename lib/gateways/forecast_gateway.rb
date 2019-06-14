require "open-uri"
require "yajl"
require "uri"

class ForecastGateway
  include ActiveSupport::Configurable

  def self.for_16_days(city)
    uri = URI::HTTP.build(
      host: config.host,
      path: config.forecast_path,
      query: {
        id: city.openweathermap_city_id,
        cnt: 16,
        APPID: config.api_key,
        units: config.units
      }.to_query
    )

    results = Rails.cache.fetch("#{config.name}/#{uri}", expires_in: 1.hour) do
      Yajl::Parser.parse(open(uri), symbolize_keys: true)
    end

    results[:list].map do |r|
      Forecast::Day.new.tap do |f|
        f.date = Time.at(r[:dt])
        f.temperature = Forecast::Conditions::Temperature.new(r[:temp][:day], r[:temp][:min], r[:temp][:max], r[:temp][:night], r[:temp][:eve], r[:temp][:morn])
        f.pressure = Forecast::Conditions::Pressure.new(r[:pressure])
        f.humidity = Forecast::Conditions::Humidity.new(r[:humidity])
        f.weather = Forecast::Conditions::Weather.new(r[:weather][0][:id], r[:weather][0][:main], r[:weather][0][:description], r[:weather][0][:icon])
        f.wind = Forecast::Conditions::Wind.new(r[:speed], r[:deg])
        f.clouds = Forecast::Conditions::Clouds.new(r[:clouds])
        f.rain = Forecast::Conditions::Rain.new(r[:rain]) if r[:rain]
        f.snow = Forecast::Conditions::Snow.new(r[:snow]) if r[:snow]
      end
    end
  end

end
