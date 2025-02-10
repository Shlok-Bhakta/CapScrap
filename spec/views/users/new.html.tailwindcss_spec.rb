require 'rails_helper'

RSpec.describe "categories/index", type: :view, skip: "View tests pending" do
  # Tests will be implemented with Selenium/Capybara when views are ready
  end

# RSpec.describe "users/new", type: :view do
#   before(:each) do
#     assign(:user, User.new(
#       role: nil,
#       first_name: "MyString",
#       last_name: "MyString",
#       email: "MyString"
#     ))
#   end

#   it "renders new user form" do
#     render

#     assert_select "form[action=?][method=?]", users_path, "post" do

#       assert_select "input[name=?]", "user[role_id]"

#       assert_select "input[name=?]", "user[first_name]"

#       assert_select "input[name=?]", "user[last_name]"

#       assert_select "input[name=?]", "user[email]"
#     end
#   end
# end
