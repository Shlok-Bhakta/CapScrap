require 'rails_helper'

RSpec.describe "Admin::Dashboards", type: :request do
  describe "GET /users" do
    it "returns http success" do
      get "/admin/dashboard/users"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /items" do
    it "returns http success" do
      get "/admin/dashboard/items"
      expect(response).to have_http_status(:success)
    end
  end

end
