require 'rails_helper'

RSpec.describe OrderStatusUpdaterService do
  before do
    @customer = Customer.create!(name: "Cliente Teste", email: "clienteteste@teste.com", address: "Rua das Rosas, 456")
    @store = Store.create!(name: "Loja Teste", description: "Uma loja teste", address: "Rua das Flores, 124")
    @order = Order.create!(customer: @customer, store: @store, total: 0.0, status: "pending", payment_status: "unsettled")
    @item1 = Item.create!(name: "Item 1", price: 10.0, stock_quantity: 10, description: "Primeiro item")
    @item2 = Item.create!(name: "Item 2", price: 5.0, stock_quantity: 10, description: "Segundo item")
    @order_item1 = OrderItem.create!(order: @order, item: @item1, quantity: 2)
    @order_item2 = OrderItem.create!(order: @order, item: @item2, quantity: 3)
    @order.order_items << [@order_item1, @order_item2]
    @service = OrderStatusUpdaterService.new(@order)
  end

  context 'update_status' do
    it 'updates status to processing' do
      expect { @service.call('processing') }.to change { @order.status }.from('pending').to('processing')
      expect { puts "A loja aceitou seu pedido! Pedido em separação!" }.to output.to_stdout
    end

    it 'updates status to confirmed if all items are present' do
      expect { @service.call('confirmed') }.to change { @order.status }.from('pending').to('confirmed')
      expect { puts "Os itens escolhidos foram separados! Pedido confirmado!" }.to output.to_stdout
    end

    it 'raises error if status is confirmed but not all items are present' do
      allow(@order).to receive(:order_items).and_return([])
      expect { @service.call('confirmed') }.to raise_error("O pedido não pôde ser confirmado, pois não foi separado!")
    end

    it 'updates status to en_route if payment is paid' do
      @order.update(payment_status: 'paid')
      expect { @service.call('en_route') }.to change { @order.status }.from('pending').to('en_route')
      expect { puts "Pagamento recebido! O pedido está em rota de entrega!" }.to output.to_stdout
    end

    it 'raises error if status is en_route but payment is not paid' do
      expect { @service.call('en_route') }.to raise_error("O pedido não pôde ser colocado em rota de entrega, pois o pagamento ainda não confirmado!")
    end

    it 'updates status to ready_for_pickup if payment is paid' do
      @order.update(payment_status: 'paid')
      expect { @service.call('ready_for_pickup') }.to change { @order.status }.from('pending').to('ready_for_pickup')
      expect { puts "Pagamento recebido! O pedido está disponível para retirada!" }.to output.to_stdout
    end

    it 'raises error if status is ready_for_pickup but payment is not paid' do
      expect { @service.call('ready_for_pickup') }.to raise_error("O pedido não está disponível para retirada, pois o pagamento ainda não confirmado!")
    end
  end
end
