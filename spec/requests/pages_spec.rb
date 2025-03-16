require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /help" do
    it "returns http success" do
      get "/pages/help"
      expect(response).to have_http_status(:success)
    end
  end
end
