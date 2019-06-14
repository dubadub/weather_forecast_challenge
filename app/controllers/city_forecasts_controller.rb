class CityForecastsController < ApplicationController

  before_action :set_city

  def show
    @forecast_days = ForecastGateway.for_16_days(@city)
  end

  private

  def set_city
    @city = City.find(params[:city_id])
  end
end
