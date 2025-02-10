require 'rails_helper'
RSpec.describe "categories/index", type: :view, skip: "View tests pending" do
  # Tests will be implemented with Selenium/Capybara when views are ready
  end

# RSpec.describe "items/new", type: :view do
#   before(:each) do
#     assign(:item, Item.new(
#       category: nil,
#       description: "MyString",
#       location: "MyString"
#     ))
#   end

#   it "renders new item form" do
#     render

#     assert_select "form[action=?][method=?]", items_path, "post" do

#       assert_select "input[name=?]", "item[category_id]"

#       assert_select "input[name=?]", "item[description]"

#       assert_select "input[name=?]", "item[location]"
#     end
#   end
# end
