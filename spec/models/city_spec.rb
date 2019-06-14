require 'rails_helper'

RSpec.describe City, type: :model do
  it "works" do
    expect(described_class.new).to be
  end

  describe "attributes" do

    describe "#name" do
      it "has name" do
        expect(described_class.new).to respond_to(:name)
      end

      it "requires name to be valid" do
        city = described_class.new

        city.valid?

        expect(city.errors.full_messages).to include(/Name can't be blank/)
      end
    end

    describe "#openweathermap_city_id" do
      it "has openweathermap_city_id" do
        expect(described_class.new).to respond_to(:openweathermap_city_id)
      end

      it "requires openweathermap_city_id to be valid" do
        city = described_class.new

        city.valid?

        expect(city.errors.full_messages).to include(/Openweathermap city can't be blank/)
      end
    end
  end
end
