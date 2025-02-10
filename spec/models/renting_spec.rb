require 'rails_helper'

RSpec.describe Renting, type: :model do
  let(:role) { Role.create!(name: 'Customer') }
  let(:category) { Category.create!(name: 'Tools') }
  let(:user) { User.create!(first_name: 'John', last_name: 'Doe', email: 'john@example.com', role: role) }
  let(:item) { Item.create!(description: 'Power drill', location: 'Storage room', category: category) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      renting = Renting.new(
        user: user,
        item: item,
        checkout_date: Date.today,
        quantity: 1
      )
      expect(renting).to be_valid
    end

    it 'is invalid without a checkout date' do
      renting = Renting.new(checkout_date: nil)
      renting.valid?
      expect(renting.errors[:checkout_date]).to include("can't be blank")
    end

    it 'is invalid without a quantity' do
      renting = Renting.new(quantity: nil)
      renting.valid?
      expect(renting.errors[:quantity]).to include("can't be blank")
    end

    it 'is invalid with quantity less than or equal to 0' do
      renting = Renting.new(quantity: 0)
      renting.valid?
      expect(renting.errors[:quantity]).to include("must be greater than 0")

      renting.quantity = -1
      renting.valid?
      expect(renting.errors[:quantity]).to include("must be greater than 0")
    end

    context 'return date validation' do
      let(:valid_renting) do
        Renting.new(
          user: user,
          item: item,
          checkout_date: Date.today,
          quantity: 1
        )
      end

      it 'is valid when return date is after checkout date' do
        valid_renting.return_date = Date.tomorrow
        expect(valid_renting).to be_valid
      end

      it 'is valid when return date is not set' do
        valid_renting.return_date = nil
        expect(valid_renting).to be_valid
      end

      it 'is invalid when return date is before checkout date' do
        valid_renting.return_date = Date.yesterday
        expect(valid_renting).not_to be_valid
        expect(valid_renting.errors[:return_date]).to include("must be after the checkout date")
      end
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      association = Renting.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to an item' do
      association = Renting.reflect_on_association(:item)
      expect(association.macro).to eq :belongs_to
    end
  end
end
