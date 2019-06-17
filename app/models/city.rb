class City < ApplicationRecord

  validates :name, :openweathermap_city_id, presence: true

  scope :search, ->(q) { q.present? ? where("lower(name) ILIKE ?", "#{q.downcase}%") : none }

end
