require "rails_helper"

RSpec.describe CityForecastsController, type: :controller do

  describe "GET #show", :vcr do
    let(:limerick) { build_limerick }
    before { allow(City).to receive(:find).and_return(limerick) }

    it "returns http success" do
      get :show, params: { city_id: limerick.id }
      expect(response).to have_http_status(:success)
    end
  end

end
