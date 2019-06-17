class AddCountryToCity < ActiveRecord::Migration[6.0]
  def change
    add_column :cities, :country, :string
  end
end
