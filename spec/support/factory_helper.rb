module FactoryHelper

  def build_limerick
    City.new(id: 42, name: "Limerick", openweathermap_city_id: 5198034, country: "US")
  end
end
