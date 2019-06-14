class CitiesController < ApplicationController
  def index
    @cities = City.search(query_param).limit(10)
  end

  private

  def query_param
    params.permit(:q).fetch(:q)
  end
end
