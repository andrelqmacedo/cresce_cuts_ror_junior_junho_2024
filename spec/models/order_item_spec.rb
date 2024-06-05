require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  context 'associations' do
    it { should belong_to(:order) }
    it { should belong_to(:item) }
  end

  context 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).only_integer.is_greater_than(0) }
  end

  # context 'callbacks' do
  #   it 'should recalculate order total after save' do
  #     order = build(:order)
  #     item = build(:item)
  #     order_item = build(:order_item, order: order, item: item)

  #     order_item.save

  #     expect(order).to receive(:calculate_total)
  #     order_item.save
  #   end

  #   it 'should recalculate order total after destroy' do
  #     expect(order).to receive(:calculate_total)
  #     order_item.destroy
  #   end
  # end

  # context '#total' do
  #   order = Order.create()
  #   item = Item.create()
  #   let(:item) { create(:item, price: 10) }
  #   let(:order_item) { build(:order_item, item: item, quantity: 3) }

  #   it 'should calculate total correctly' do
  #     expect(order_item.total).to eq(30)
  #   end
  # end
end
