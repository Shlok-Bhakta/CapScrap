require 'rails_helper'

RSpec.describe "rentings/show", type: :view do
  before(:each) do
    assign(:renting, Renting.create!(
      user: nil,
      item: nil,
      quantity: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
  end
end
