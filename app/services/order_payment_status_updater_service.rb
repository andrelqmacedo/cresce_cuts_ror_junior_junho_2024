class OrderPaymentStatusUpdaterService
  def initialize(order)
    @order = order
  end

  def call(new_status)
    case new_status
    when "paid"
      @order.update(payment_status: new_status)
      puts "Pagamento recebido!"
    when "cancelled"
      @order.update(payment_status: new_status)
      puts "Pagamento não identificado!"
    end
  end
end
