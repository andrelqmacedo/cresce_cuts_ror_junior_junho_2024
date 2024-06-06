class OrderTotalCalculatorService
  def initialize(order)
    @order = order
  end

  def calculate
    total = @order.order_items.sum { |order_item| order_item.total }
    @order.update(total: total)
  end
end
