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

    # Adicionar verificações adicionais
    @order.reload
    puts "Order ID: #{@order.id}"
    puts "OrderItem 1: #{@order_item1.inspect}"
    puts "OrderItem 2: #{@order_item2.inspect}"
    puts "Order Items: #{@order.order_items.inspect}"
  end

  describe '#calculate' do
    it 'calculates the total for the order' do
      service = OrderTotalCalculatorService.new(@order)
      service.calculate

      # Verificar associação entre itens do pedido e o pedido
      expect(@order.order_items.count).to eq(2)
      expect(@order.order_items.pluck(:item_id)).to match_array([@item1.id, @item2.id])

      # Verificar preços e quantidades
      order_item1 = @order.order_items.find_by(item_id: @item1.id)
      order_item2 = @order.order_items.find_by(item_id: @item2.id)

      expect(order_item1.quantity).to eq(2)
      expect(order_item1.item.price).to eq(10.0)
      expect(order_item2.quantity).to eq(3)
      expect(order_item2.item.price).to eq(5.0)

      # Verificar o total calculado manualmente
      expected_total = 2 * 10.0 + 3 * 5.0
      expect(@order.total).to be_within(0.01).of(expected_total)
    end
  end
end
