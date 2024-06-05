require 'rails_helper'

RSpec.describe Item, type: :model do
  context "associations" do
    it { should have_many(:order_items) }
    it { should have_many(:cart_items) }
  end

  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:stock_quantity) }

    it { should validate_numericality_of(:price) }
    it { should validate_numericality_of(:stock_quantity) }
  end
end
