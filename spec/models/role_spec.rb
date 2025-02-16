require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'validations' do
    it 'is valid with a name' do
      role = Role.new(name: 'Admin')
      expect(role).to be_valid
    end

    it 'is invalid without a name' do
      role = Role.new(name: nil)
      expect(role).not_to be_valid
    end

    it 'is invalid with a duplicate name' do
      Role.create!(name: 'Admin')
      role = Role.new(name: 'Admin')
      expect(role).not_to be_valid
    end
  end

  describe 'associations' do
    it 'has many users' do
      association = Role.reflect_on_association(:users)
      expect(association.macro).to eq :has_many
    end
  end
end
