require 'rails_helper'

RSpec.describe CartItem, type: :model do
  context "associations" do
    it { should belong_to(:cart) }
    it { should belong_to(:item) }
  end

  context "validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity) }
  end
end
