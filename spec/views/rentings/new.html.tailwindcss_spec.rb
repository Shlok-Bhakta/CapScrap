require 'rails_helper'

RSpec.describe "categories/index", type: :view, skip: "View tests pending" do
    # Tests will be implemented with Selenium/Capybara when views are ready
  end

# RSpec.describe "rentings/new", type: :view do
#   before(:each) do
#     assign(:renting, Renting.new(
#       user: nil,
#       item: nil,
#       quantity: 1
#     ))
#   end

#   it "renders new renting form" do
#     render

#     assert_select "form[action=?][method=?]", rentings_path, "post" do

#       assert_select "input[name=?]", "renting[user_id]"

#       assert_select "input[name=?]", "renting[item_id]"

#       assert_select "input[name=?]", "renting[quantity]"
#     end
#   end
# end
