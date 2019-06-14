module Forecast
  module Conditions
    class Temperature < Struct.new(:day, :min, :max, :night, :evening, :morning)

    end
  end
end
