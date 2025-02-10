require 'rails_helper'

RSpec.describe User, type: :model do
  let(:role) { Role.create!(name: 'Customer') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        email: 'john@example.com',
        role: role
      )
      expect(user).to be_valid
    end

    it 'is invalid without a first name' do
      user = User.new(first_name: nil)
      user.valid?
      expect(user.errors[:first_name]).to include("can't be blank")
    end

    it 'is invalid without a last name' do
      user = User.new(last_name: nil)
      user.valid?
      expect(user.errors[:last_name]).to include("can't be blank")
    end

    it 'is invalid without an email' do
      user = User.new(email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      User.create!(
        first_name: 'John',
        last_name: 'Doe',
        email: 'john@example.com',
        role: role
      )
      user = User.new(
        first_name: 'Jane',
        last_name: 'Doe',
        email: 'john@example.com',
        role: role
      )
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it 'is invalid with an invalid email format' do
      user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        email: 'invalid-email',
        role: role
      )
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("must be a valid email address")
    end
  end

  describe 'associations' do
    it 'belongs to a role' do
      association = User.reflect_on_association(:role)
      expect(association.macro).to eq :belongs_to
    end

    it 'has many rentings' do
      association = User.reflect_on_association(:rentings)
      expect(association.macro).to eq :has_many
    end

    it 'has many items through rentings' do
      association = User.reflect_on_association(:items)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :rentings
    end

    it 'has many purchases' do
      association = User.reflect_on_association(:purchases)
      expect(association.macro).to eq :has_many
    end

    it 'has many purchased items through purchases' do
      association = User.reflect_on_association(:purchased_items)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :purchases
      expect(association.options[:source]).to eq :item
    end
  end

  describe '#name' do
    it 'returns the full name' do
      user = User.new(first_name: 'John', last_name: 'Doe')
      expect(user.name).to eq('John Doe')
    end
  end
end
