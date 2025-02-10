require 'rails_helper'

RSpec.describe "purchases/show", type: :view do
  before(:each) do
    assign(:purchase, Purchase.create!(
      user: nil,
      item: nil,
      purchased_quantity: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
  end
end
