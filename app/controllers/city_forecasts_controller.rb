class CityForecastsController < ApplicationController
  def show
    @forecast = 16.times.map do
      Forecast::Day.new.tap do |f|
        f.date = Time.at(1406080800)
        f.temperature = Forecast::Conditions::Temperature.new
        f.pressure = Forecast::Conditions::Pressure.new
        f.humidity = Forecast::Conditions::Humidity.new
        f.weather = Forecast::Conditions::Weather.new
        f.wind = Forecast::Conditions::Wind.new
        f.clouds = Forecast::Conditions::Clouds.new
        f.rain = Forecast::Conditions::Rain.new
        f.snow = Forecast::Conditions::Snow.new
      end
    end
  end
end
