require 'rails_helper'

RSpec.describe CityForecastsController, type: :controller do

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { city_id: 42 }
      expect(response).to have_http_status(:success)
    end
  end

end
