require 'rails_helper'

RSpec.describe "categories/index", type: :view, skip: "View tests pending" do
  # Tests will be implemented with Selenium/Capybara when views are ready
  end

# RSpec.describe "roles/index", type: :view do
#   before(:each) do
#     assign(:roles, [
#       Role.create!(
#         name: "Name"
#       ),
#       Role.create!(
#         name: "Name"
#       )
#     ])
#   end

#   it "renders a list of roles" do
#     render
#     cell_selector = 'div>p'
#     assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
#   end
# end
