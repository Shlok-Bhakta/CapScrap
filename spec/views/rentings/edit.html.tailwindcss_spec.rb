require 'rails_helper'

RSpec.describe "rentings/edit", type: :view do
  let(:renting) {
    Renting.create!(
      user: nil,
      item: nil,
      quantity: 1
    )
  }

  before(:each) do
    assign(:renting, renting)
  end

  it "renders the edit renting form" do
    render

    assert_select "form[action=?][method=?]", renting_path(renting), "post" do

      assert_select "input[name=?]", "renting[user_id]"

      assert_select "input[name=?]", "renting[item_id]"

      assert_select "input[name=?]", "renting[quantity]"
    end
  end
end
