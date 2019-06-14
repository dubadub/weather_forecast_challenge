require 'rails_helper'

RSpec.describe CitiesController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index, params: { q: "hello" }
      expect(response).to have_http_status(:success)
    end
  end

end
