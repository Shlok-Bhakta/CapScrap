require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/purchases", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Purchase. As you add validations to Purchase, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Purchase.create! valid_attributes
      get purchases_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      purchase = Purchase.create! valid_attributes
      get purchase_url(purchase)
      expect(response).to be_successful
    end
  end

  # view is not implemented yet
  # describe "GET /new" do
  #   it "renders a successful response" do
  #     get new_purchase_url
  #     expect(response).to be_successful
  #   end
  # end

  describe "GET /edit" do
    it "renders a successful response" do
      purchase = Purchase.create! valid_attributes
      get edit_purchase_url(purchase)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Purchase" do
        expect {
          post purchases_url, params: { purchase: valid_attributes }
        }.to change(Purchase, :count).by(1)
      end

      it "redirects to the created purchase" do
        post purchases_url, params: { purchase: valid_attributes }
        expect(response).to redirect_to(purchase_url(Purchase.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Purchase" do
        expect {
          post purchases_url, params: { purchase: invalid_attributes }
        }.to change(Purchase, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post purchases_url, params: { purchase: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested purchase" do
        purchase = Purchase.create! valid_attributes
        patch purchase_url(purchase), params: { purchase: new_attributes }
        purchase.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the purchase" do
        purchase = Purchase.create! valid_attributes
        patch purchase_url(purchase), params: { purchase: new_attributes }
        purchase.reload
        expect(response).to redirect_to(purchase_url(purchase))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        purchase = Purchase.create! valid_attributes
        patch purchase_url(purchase), params: { purchase: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested purchase" do
      purchase = Purchase.create! valid_attributes
      expect {
        delete purchase_url(purchase)
      }.to change(Purchase, :count).by(-1)
    end

    it "redirects to the purchases list" do
      purchase = Purchase.create! valid_attributes
      delete purchase_url(purchase)
      expect(response).to redirect_to(purchases_url)
    end
  end
end
