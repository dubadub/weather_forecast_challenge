module Forecast
  module Conditions
    class Weather < Struct.new(:id, :main, :description, :icon)

    end
  end
end
