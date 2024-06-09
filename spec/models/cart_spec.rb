require "rails_helper"

RSpec.describe Cart, type: :model do
  context "associations" do
    it { should belong_to(:customer) }
    it { should have_many(:cart_items) }
    it { should have_many(:items).through(:cart_items) }
  end

  context "validations" do
    it { should validate_presence_of(:customer) }
  end
end
