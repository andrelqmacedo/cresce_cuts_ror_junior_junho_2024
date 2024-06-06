require 'rails_helper'

RSpec.describe Order, type: :model do
  context "associations" do
    it { should belong_to (:customer) }
    it { should belong_to (:store) }
    it { should have_many (:order_items) }
    it { should have_many(:items).through(:order_items) }
  end

  context "validations" do
    it { should validate_presence_of(:total) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:payment_status) }

    it { should validate_numericality_of(:total) }
  end

  # context "#adjust_stock" do
  #   let!(:customer) { Customer.create(name: 'Joao Silva', email: 'joaosilva@example.com') }
  #   let!(:store) { Store.create(name: 'Loja Teste', description: 'Uma loja teste', address: 'Rua das Flores, 123') }
  #   let!(:item) { Item.create(name: 'Item Teste', description: "Um item teste", price: 10, stock_quantity: 10) }
  #   let!(:order) { Order.create(customer: customer, store: store, status: 'pending', payment_status: 'unsettled', total: 0) }
  #   let!(:order_item) { OrderItem.create(order: order, item: item, quantity: 2, total: 20) }

  #   it "decrements the stock quantity when order is marked as paid" do
  #     order.update(status: :paid)
  #     expect(item.reload.stock_quantity).to eq(8)
  #   end

  #   it "increments the stock quantity when order is marked as cancelled" do
  #     order.update(status: :cancelled)
  #     expect(item.reload.stock_quantity).to eq(12)
  #   end

  #   it "does not change the stock quantity if status is neither paid nor cancelled" do
  #     order.update(status: :processing)
  #     expect(item.reload.stock_quantity).to eq(10)
  #   end
  # end
end