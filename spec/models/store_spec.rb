require "rails_helper"

RSpec.describe Store, type: :model do
  context "associations" do
    it { should have_many(:orders) }
  end

  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:address) }

    it { should validate_length_of(:name) }
  end
end
