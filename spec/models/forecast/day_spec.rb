require 'rails_helper'

RSpec.describe Forecast::Day, type: :model do
  it "works" do
    expect(described_class.new).to be
  end

  describe "attributes" do
    describe "#date" do
      it "has date" do
        expect(described_class.new).to respond_to(:date)
      end

      it "can create it like regular model" do
        day_forecast = described_class.new
        date = "2019/06/14"
        day_forecast.date = date
        expect(day_forecast.date).to eq(date)
      end
    end
  end
end
