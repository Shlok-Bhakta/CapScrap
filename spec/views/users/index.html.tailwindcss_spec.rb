require 'rails_helper'

RSpec.describe "categories/index", type: :view, skip: "View tests pending" do
    # Tests will be implemented with Selenium/Capybara when views are ready
  end

# RSpec.describe "users/index", type: :view do
#   before(:each) do
#     assign(:users, [
#       User.create!(
#         role: nil,
#         first_name: "First Name",
#         last_name: "Last Name",
#         email: "Email"
#       ),
#       User.create!(
#         role: nil,
#         first_name: "First Name",
#         last_name: "Last Name",
#         email: "Email"
#       )
#     ])
#   end

#   it "renders a list of users" do
#     render
#     cell_selector = 'div>p'
#     assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
#     assert_select cell_selector, text: Regexp.new("First Name".to_s), count: 2
#     assert_select cell_selector, text: Regexp.new("Last Name".to_s), count: 2
#     assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
#   end
# end
