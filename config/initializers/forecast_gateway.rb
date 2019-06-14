ForecastGateway.configure do |config|
  config.name = "openweathermap"
  config.api_key = Rails.application.credentials.openweathermap_key
  config.units = :metric
  config.host = "api.openweathermap.org"
  config.forecast_path = "/data/2.5/forecast/daily"
end
