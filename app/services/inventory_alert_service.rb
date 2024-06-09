class InventoryAlertService
  def initialize(order)
    @order = order
  end

  def call
    @order.order_items.each do |order_item|
      if order_item.item.stock_quantity <= 2
        send_low_stock_alert(order_item.item, order_item.quantity)
      end
    end
  end

  private

  def send_low_stock_alert(item, quantity)
    puts "Alerta de estoque baixo! O item #{item.name} possui apenas #{item.stock_quantity} unidades restantes."
  end
end
