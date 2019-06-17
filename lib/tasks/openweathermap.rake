require "open-uri"

require "yajl"

OWM_CITIES_JSON_URL = "http://bulk.openweathermap.org/sample/current.city.list.min.json.gz".freeze

namespace :openweathermap do

  desc "Import all cities into database from openweathermap.org"
  task import_cities: :environment do
    file = Rails.root.join("tmp", "cities.json")

    IO.copy_stream(Zlib::GzipReader.new(open(OWM_CITIES_JSON_URL)), file)

    cities = Yajl::Parser.parse(File.new(file), symbolize_keys: true).map! do |c|
      { name: c[:name], openweathermap_city_id: c[:id], country: c[:country] }
    end

    City.insert_all(cities)
  end

end
