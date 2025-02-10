require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:category) { Category.create!(name: 'Tools') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      item = Item.new(
        description: 'Power drill',
        location: 'Storage room',
        category: category
      )
      expect(item).to be_valid
    end

    it 'is invalid without a description' do
      item = Item.new(description: nil)
      item.valid?
      expect(item.errors[:description]).to include("can't be blank")
    end

    it 'is invalid without a location' do
      item = Item.new(location: nil)
      item.valid?
      expect(item.errors[:location]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a category' do
      association = Item.reflect_on_association(:category)
      expect(association.macro).to eq :belongs_to
    end

    it 'has many rentings' do
      association = Item.reflect_on_association(:rentings)
      expect(association.macro).to eq :has_many
    end

    it 'has many users through rentings' do
      association = Item.reflect_on_association(:users)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :rentings
    end

    it 'has many purchases' do
      association = Item.reflect_on_association(:purchases)
      expect(association.macro).to eq :has_many
    end

    it 'has many purchasers through purchases' do
      association = Item.reflect_on_association(:purchasers)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :purchases
      expect(association.options[:source]).to eq :user
    end
  end
end
