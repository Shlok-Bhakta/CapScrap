require 'rails_helper'

RSpec.describe "categories/index", type: :view, skip: "View tests pending" do
  # Tests will be implemented with Selenium/Capybara when views are ready
  end

# RSpec.describe "purchases/index", type: :view do
#   before(:each) do
#     assign(:purchases, [
#       Purchase.create!(
#         user: nil,
#         item: nil,
#         purchased_quantity: 2
#       ),
#       Purchase.create!(
#         user: nil,
#         item: nil,
#         purchased_quantity: 2
#       )
#     ])
#   end

#   it "renders a list of purchases" do
#     render
#     cell_selector = 'div>p'
#     assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
#     assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
#     assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
#   end
# end
