require 'rails_helper'

RSpec.describe ForecastGateway do
  it "works" do
    expect(described_class.new).to be
  end

  describe "#for_16_days", :vcr do

    it "returns 16 days forecast" do
      city = build_limerick
      expect(described_class.for_16_days(city).size).to eq(16)
    end

  end

end
