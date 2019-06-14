class City < ApplicationRecord

  validates :name, :openweathermap_city_id, presence: true

end
