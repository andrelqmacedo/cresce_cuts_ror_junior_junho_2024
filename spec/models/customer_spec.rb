require 'rails_helper'

RSpec.describe Customer, type: :model do
  context "associations" do
    it { should have_many(:orders) }
    it { should have_many(:carts) }
  end

  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:address) }

    it { should validate_uniqueness_of(:email) }
    it { should allow_value('example@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
  end
end
