require 'rails_helper'

RSpec.describe "categories/index", type: :view, skip: "View tests pending" do
    # Tests will be implemented with Selenium/Capybara when views are ready
  end

# RSpec.describe "rentings/index", type: :view do
#   before(:each) do
#     assign(:rentings, [
#       Renting.create!(
#         user: nil,
#         item: nil,
#         quantity: 2
#       ),
#       Renting.create!(
#         user: nil,
#         item: nil,
#         quantity: 2
#       )
#     ])
#   end

#   it "renders a list of rentings" do
#     render
#     cell_selector = 'div>p'
#     assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
#     assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
#     assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
#   end
# end
