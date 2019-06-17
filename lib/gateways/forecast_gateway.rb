require "open-uri"
require "yajl"
require "uri"

class ForecastGateway
  include ActiveSupport::Configurable
  RETRY_TIMES = 3

  class ApiError < StandardError; end

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
      try = 0

      begin
        Yajl::Parser.parse(open(uri), symbolize_keys: true)
      rescue SocketError, Timeout::Error, OpenURI::HTTPError => error
        try = try + 1

        try <= RETRY_TIMES ? retry : raise(ApiError, error.message)
      end
    end

    results[:list].map do |r|
      Forecast::Day.new.tap do |f|
        f.date = Time.at(r[:dt])
        f.temperature = Forecast::Conditions::Temperature.new(r[:temp][:day].round, r[:temp][:min].round, r[:temp][:max].round, r[:temp][:night].round, r[:temp][:eve].round, r[:temp][:morn].round)
        f.pressure = Forecast::Conditions::Pressure.new(r[:pressure])
        f.humidity = Forecast::Conditions::Humidity.new(r[:humidity])
        f.weather = Forecast::Conditions::Weather.new(r[:weather][0][:id], r[:weather][0][:main], r[:weather][0][:description], r[:weather][0][:icon])
        f.wind = Forecast::Conditions::Wind.new(r[:speed].round, r[:deg])
        f.clouds = Forecast::Conditions::Clouds.new(r[:clouds])
        f.rain = Forecast::Conditions::Rain.new(r[:rain]) if r[:rain]
        f.snow = Forecast::Conditions::Snow.new(r[:snow]) if r[:snow]
      end
    end
  end

end
