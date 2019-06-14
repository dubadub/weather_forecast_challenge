require "rails_helper"

RSpec.describe CityForecastsController, type: :controller do

  describe "GET #show" do
    before { allow(City).to receive(:find).and_return(City.new(name: "Uryupinsk")) }

    it "returns http success" do
      get :show, params: { city_id: 42 }
      expect(response).to have_http_status(:success)
    end
  end

end
