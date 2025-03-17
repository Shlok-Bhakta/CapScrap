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

RSpec.describe "/rentings", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Renting. As you add validations to Renting, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Renting.create! valid_attributes
      get rentings_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      renting = Renting.create! valid_attributes
      get renting_url(renting)
      expect(response).to be_successful
    end
  end

  # view is not implemented yet
  # describe "GET /new" do
  #   it "renders a successful response" do
  #     get new_renting_url
  #     expect(response).to be_successful
  #   end
  # end

  describe "GET /edit" do
    it "renders a successful response" do
      renting = Renting.create! valid_attributes
      get edit_renting_url(renting)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Renting" do
        expect {
          post rentings_url, params: { renting: valid_attributes }
        }.to change(Renting, :count).by(1)
      end

      it "redirects to the created renting" do
        post rentings_url, params: { renting: valid_attributes }
        expect(response).to redirect_to(renting_url(Renting.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Renting" do
        expect {
          post rentings_url, params: { renting: invalid_attributes }
        }.to change(Renting, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post rentings_url, params: { renting: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested renting" do
        renting = Renting.create! valid_attributes
        patch renting_url(renting), params: { renting: new_attributes }
        renting.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the renting" do
        renting = Renting.create! valid_attributes
        patch renting_url(renting), params: { renting: new_attributes }
        renting.reload
        expect(response).to redirect_to(renting_url(renting))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        renting = Renting.create! valid_attributes
        patch renting_url(renting), params: { renting: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested renting" do
      renting = Renting.create! valid_attributes
      expect {
        delete renting_url(renting)
      }.to change(Renting, :count).by(-1)
    end

    it "redirects to the rentings list" do
      renting = Renting.create! valid_attributes
      delete renting_url(renting)
      expect(response).to redirect_to(rentings_url)
    end
  end
end
