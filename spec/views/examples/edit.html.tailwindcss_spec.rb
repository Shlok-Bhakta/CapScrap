require 'rails_helper'

RSpec.describe "examples/edit", type: :view do
  let(:example) {
    Example.create!(
      name: "MyString"
    )
  }

  before(:each) do
    assign(:example, example)
  end

  it "renders the edit example form" do
    render

    assert_select "form[action=?][method=?]", example_path(example), "post" do
      assert_select "input[name=?]", "example[name]"
    end
  end
end
