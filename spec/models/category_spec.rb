require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'validations' do
    it 'is valid with a name' do
      category = Category.new(name: 'Tools')
      expect(category).to be_valid
    end

    it 'is invalid without a name' do
      category = Category.new(name: nil)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with a duplicate name' do
      Category.create!(name: 'Tools')
      category = Category.new(name: 'Tools')
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include('has already been taken')
    end
  end

  describe 'associations' do
    it 'has many items' do
      association = Category.reflect_on_association(:items)
      expect(association.macro).to eq :has_many
    end
  end
end
