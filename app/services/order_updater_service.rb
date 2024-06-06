class OrderUpdaterService
  def initialize(order)
    @order = order
  end

  def update_status(new_status)

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

  def update_payment_status(new_status)
    case new_status
    when "paid"
      @order.update(payment_status: new_status)
      puts "Pagamento recebido!"
    when "cancelled"
      @order.update(payment_status: new_status)
      puts "Pagamento não identificado!"
    end
  end

  private

  def all_items_present?
    @order.order_items.all? { |item| item.present? }
  end
end
