class OrderTotalCalculatorService
  def initialize(order)
    @order = order
  end

  def calculate
    total = 0.0
    @order.order_items.each do |order_item|
      order_item_total = order_item.quantity * order_item.item.price
      total += order_item_total
      puts "OrderItem Total: #{order_item_total} | Running Total: #{total}"
    end
    @order.update(total: total)
    puts "Final Total: #{total}"
  end
end
