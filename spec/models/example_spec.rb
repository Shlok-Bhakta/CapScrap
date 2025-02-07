require 'rails_helper'

RSpec.describe Example, type: :model do
  subject { Example.new(name: "Sample Name") }

  context "validations" do
    it "is valid with a name" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).not_to be_valid
    end
  end
end
