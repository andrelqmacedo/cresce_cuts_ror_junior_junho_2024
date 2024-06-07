class OrderTotalCalculatorService
  def initialize(order)
    @order = order
  end

  def calculate
    total = 0.0
    @order.order_items.each do |order_item|
      order_item_total = order_item.quantity * order_item.item.price
      total += order_item_total
    end
    @order.update(total: total)
  end
end
