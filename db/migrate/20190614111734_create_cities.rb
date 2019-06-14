class CreateCities < ActiveRecord::Migration[6.0]
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :openweathermap_city_id

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
