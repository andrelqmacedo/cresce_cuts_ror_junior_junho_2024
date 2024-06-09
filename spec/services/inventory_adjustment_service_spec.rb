require "rails_helper"

RSpec.describe InventoryAdjustmentService do
  before do
    @customer = Customer.create!(name: "Cliente Teste", email: "clienteteste@teste.com", address: "Rua das Rosas, 456")
    @store = Store.create!(name: "Loja Teste", description: "Uma loja teste", address: "Rua das Flores, 124")
    @order = Order.create!(customer: @customer, store: @store, total: 0.0, status: "pending", payment_status: "unsettled")
    @item1 = Item.create!(name: "Item 1", price: 10.0, stock_quantity: 2, description: "Primeiro item")
    @item2 = Item.create!(name: "Item 2", price: 5.0, stock_quantity: 3, description: "Segundo item")
    @order_item1 = OrderItem.create!(order: @order, item: @item1, quantity: 2)
    @order_item2 = OrderItem.create!(order: @order, item: @item2, quantity: 3)
    @order.reload
  end

  describe "#call" do
    context "when payment status is not changed" do
      it "does not adjust stock" do
        @order.update(payment_status: "unsettled")
        InventoryAdjustmentService.new(@order).call

        expect(@order.order_items.first.item.stock_quantity).to eq(@order.order_items.first.quantity)
      end
    end

    context "when payment status is changed to paid" do
      it "decrements stock for each order item" do
        order_item = OrderItem.new(order: @order, item: @item1, quantity: 2)
        order_item.save!

        @order.update(payment_status: "unsettled")
        @order.update(payment_status: "paid")

        expect(@order.order_items.first.item.stock_quantity).to eq(0)
      end
    end

    context "when payment status is changed to cancelled" do
      it "increments stock for each order item" do
        order_item = OrderItem.new(order: @order, item: @item1, quantity: 2)
        order_item.save!

        @order.update(payment_status: "paid")
        @order.update(payment_status: "cancelled")

        expect(@order.order_items.first.item.stock_quantity).to eq(2)
      end
    end
  end
end
