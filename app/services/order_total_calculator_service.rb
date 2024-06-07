class OrderTotalCalculatorService
  def initialize(order)
    @order = order
  end

  def calculate
    total = @order.order_items.sum do |order_item| {}
      order_item_total = order_item.quantity * order_item.item.price
      order_item_total
    end
    @order.update(total: total)
  end
end
