require 'rails_helper'

RSpec.describe "Admin::Dashboards", type: :request do
  # user wont be authorized to access this page so itll give a 302 redirect
  describe "GET /users" do
    it "returns http success" do
      get "/admin/dashboard/users"
      expect(response).to have_http_status(302)
    end
  end

  describe "GET /items" do
    it "returns http success" do
      get "/admin/dashboard/items"
      expect(response).to have_http_status(302)
    end
  end
end
