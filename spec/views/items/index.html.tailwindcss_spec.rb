require 'rails_helper'

RSpec.describe "categories/index", type: :view, skip: "View tests pending" do
  # Tests will be implemented with Selenium/Capybara when views are ready
  end

# RSpec.describe "items/index", type: :view do
#   before(:each) do
#     assign(:items, [
#       Item.create!(
#         category: nil,
#         description: "Description",
#         location: "Location"
#       ),
#       Item.create!(
#         category: nil,
#         description: "Description",
#         location: "Location"
#       )
#     ])
#   end

#   it "renders a list of items" do
#     render
#     cell_selector = 'div>p'
#     assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
#     assert_select cell_selector, text: Regexp.new("Description".to_s), count: 2
#     assert_select cell_selector, text: Regexp.new("Location".to_s), count: 2
#   end
# end
