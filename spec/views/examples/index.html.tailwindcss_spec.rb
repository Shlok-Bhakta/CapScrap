require 'rails_helper'

RSpec.describe "examples/index", type: :view do
  before(:each) do
    assign(:examples, [
      Example.create!(
        name: "Name"
      ),
      Example.create!(
        name: "Name"
      )
    ])
  end

  it "renders a list of examples" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
  end
end
