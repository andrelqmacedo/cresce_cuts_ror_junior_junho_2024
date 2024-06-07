require 'rails_helper'

RSpec.describe OrderTotalCalculatorService do
  before do
    @customer = Customer.create!(name: "Cliente Teste", email: "clienteteste@teste.com", address: "Rua das Rosas, 456")
    @store = Store.create!(name: "Loja Teste", description: "Uma loja teste", address: "Rua das Flores, 124")
    @order = Order.create!(customer: @customer, store: @store, total: 0.0, status: "pending", payment_status: "unsettled")
    @item1 = Item.create!(name: "Item 1", price: 10.0, stock_quantity: 10, description: "Primeiro item")
    @item2 = Item.create!(name: "Item 2", price: 5.0, stock_quantity: 10, description: "Segundo item")
    @order_item1 = OrderItem.create!(order: @order, item: @item1, quantity: 2)
    @order_item2 = OrderItem.create!(order: @order, item: @item2, quantity: 3)
  end

  describe '#calculate' do
    it 'calculates the total for the order' do
      service = OrderTotalCalculatorService.new(@order)
      service.calculate
      expect(@order.total).to eq(2 * 10.0 + 3 * 5.0)
    end
  end
end
