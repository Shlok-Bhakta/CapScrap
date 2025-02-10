require 'rails_helper'

RSpec.describe "categories/index", type: :view, skip: "View tests pending" do
  # Tests will be implemented with Selenium/Capybara when views are ready
  end

# RSpec.describe "items/edit", type: :view do
#   let(:item) {
#     Item.create!(
#       category: nil,
#       description: "MyString",
#       location: "MyString"
#     )
#   }

#   before(:each) do
#     assign(:item, item)
#   end

#   it "renders the edit item form" do
#     render

#     assert_select "form[action=?][method=?]", item_path(item), "post" do

#       assert_select "input[name=?]", "item[category_id]"

#       assert_select "input[name=?]", "item[description]"

#       assert_select "input[name=?]", "item[location]"
#     end
#   end
# end
