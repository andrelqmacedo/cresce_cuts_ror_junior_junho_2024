require 'rails_helper'

RSpec.describe OrderPaymentStatusUpdaterService do
  before do
    @customer = Customer.create!(name: "Cliente Teste", email: "clienteteste@teste.com", address: "Rua das Rosas, 456")
    @store = Store.create!(name: "Loja Teste", description: "Uma loja teste", address: "Rua das Flores, 124")
    @order = Order.create!(customer: @customer, store: @store, total: 0.0, status: "pending", payment_status: "unsettled")
    @item1 = Item.create!(name: "Item 1", price: 10.0, stock_quantity: 10, description: "Primeiro item")
    @item2 = Item.create!(name: "Item 2", price: 5.0, stock_quantity: 10, description: "Segundo item")
    @order_item1 = OrderItem.create!(order: @order, item: @item1, quantity: 2)
    @order_item2 = OrderItem.create!(order: @order, item: @item2, quantity: 3)
    @order.order_items << [@order_item1, @order_item2]
    @service = OrderPaymentStatusUpdaterService.new(@order)
  end

  context '#update_payment_status' do
    it 'updates payment status to paid' do
      expect { @service.call('paid') }.to change { @order.payment_status }.from('unsettled').to('paid')
      expect { puts "Pagamento recebido!" }.to output.to_stdout
    end

    it 'updates payment status to cancelled' do
      expect { @service.call('cancelled') }.to change { @order.payment_status }.from('unsettled').to('cancelled')
      expect { puts "Pagamento não identificado!" }.to output.to_stdout
    end
  end
end
