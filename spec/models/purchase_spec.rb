require 'rails_helper'

RSpec.describe Purchase, type: :model do
  let(:role) { Role.create!(name: 'Customer') }
  let(:category) { Category.create!(name: 'Tools') }
  let(:user) { User.create!(first_name: 'John', last_name: 'Doe', email: 'john@example.com', role: role) }
  let(:item) { Item.create!(description: 'Power drill', location: 'Storage room', category: category) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      purchase = Purchase.new(
        user: user,
        item: item,
        purchase_date: Date.today,
        purchased_quantity: 1
      )
      expect(purchase).to be_valid
    end

    it 'is invalid without a purchase date' do
      purchase = Purchase.new(purchase_date: nil)
      purchase.valid?
      expect(purchase.errors[:purchase_date]).to include("can't be blank")
    end

    it 'is invalid without a purchased quantity' do
      purchase = Purchase.new(purchased_quantity: nil)
      purchase.valid?
      expect(purchase.errors[:purchased_quantity]).to include("can't be blank")
    end

    it 'is invalid with purchased quantity less than or equal to 0' do
      purchase = Purchase.new(purchased_quantity: 0)
      purchase.valid?
      expect(purchase.errors[:purchased_quantity]).to include("must be greater than 0")

      purchase.purchased_quantity = -1
      purchase.valid?
      expect(purchase.errors[:purchased_quantity]).to include("must be greater than 0")
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      association = Purchase.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to an item' do
      association = Purchase.reflect_on_association(:item)
      expect(association.macro).to eq :belongs_to
    end
  end
end
