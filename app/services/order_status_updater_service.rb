class OrderStatusUpdaterService
  def initialize(order)
    @order = order
  end

  def call(new_status)
    case new_status
    when "processing"
      @order.update(status: new_status)
      puts "A loja aceitou seu pedido! Pedido em separação!"
    when "confirmed"
      if all_items_present?
        @order.update(status: new_status)
        puts "Os itens escolhidos foram separados! Pedido confirmado!"
      else
        raise "O pedido não pôde ser confirmado, pois não foi separado!"
      end
    when "en_route"
      if @order.payment_status == "paid"
        @order.update(status: new_status)
        puts "Pagamento recebido! O pedido está em rota de entrega!"
      else
        raise "O pedido não pôde ser colocado em rota de entrega, pois o pagamento ainda não confirmado!"
      end
    when "ready_for_pickup"
      if @order.payment_status == "paid"
        @order.update(status: new_status)
        puts "Pagamento recebido! O pedido está disponível para retirada!"
      else
        raise "O pedido não está disponível para retirada, pois o pagamento ainda não confirmado!"
      end
    end
  end

  private

  def all_items_present?
    @order.order_items.any? && @order.order_items.all? { |order_item| order_item.quantity > 0 }
  end
end
