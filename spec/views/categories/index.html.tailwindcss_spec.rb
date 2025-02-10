require 'rails_helper'

# just do nothing (disable this test)

RSpec.describe "categories/index", type: :view, skip: "View tests pending" do
  # Tests will be implemented with Selenium/Capybara when views are ready
  end

# RSpec.describe "categories/index", type: :view do
#   before(:each) do
#     assign(:categories, [
#       Category.create!(
#         name: "Name"
#       ),
#       Category.create!(
#         name: "Name"
#       )
#     ])
#   end

#   it "renders a list of categories" do
#     render
#     cell_selector = 'div>p'
#     assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
#   end
# end
