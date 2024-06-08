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

  context 'after_save, after_update, after_destroy' do
    before(:each) do
      @customer = Customer.create!(name: "Cliente Teste", email: "clienteteste@teste.com", address: "Rua das Rosas, 456")
      @store = Store.create(name: "Loja Teste", description: "Uma loja teste", address: "Rua das Flores, 124")
      @order = Order.create(customer: @customer, store: @store, total: 0.0, status: "pending", payment_status: "unsettled")
      @item1 = Item.create(name: "Item 1", price: 10.0, stock_quantity: 10, description: "Primeiro item")
      @item2 = Item.create(name: "Item 2", price: 5.0, stock_quantity: 10, description: "Segundo item")
    end

    it 'recalculates the order total after creation' do
      OrderItem.create(order: @order, item: @item1, quantity: 2)
      @order.reload
      OrderItem.create(order: @order, item: @item2, quantity: 3)
      @order.reload
      
      expect(@order.total).to eq(2 * 10.0 + 3 * 5.0)
    end

    it 'recalculates the order total after update' do
      order_item = OrderItem.create(order: @order, item: @item1, quantity: 2)
      @order.reload
      order_item.update(quantity: 3)

      expect(@order.total).to eq(3 * 10.0)
    end

    it 'recalculates the order total after destruction' do
      order_item1 = OrderItem.create(order: @order, item: @item1, quantity: 2)
      order_item2 = OrderItem.create(order: @order, item: @item2, quantity: 3)
      @order.reload
      order_item1.destroy

      expect(@order.total).to eq(3 * 5.0)
    end
  end
end
