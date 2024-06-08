class InventoryAdjustmentService

    def initialize(order)
      @order = order
    end
  
    def call
      return unless payment_status_changed? && paid_or_cancelled?
  
      @order.order_items.each do |order_item|
        adjust_stock(order_item.item, order_item.quantity)
      end
    end
  
    private
  
    def adjust_stock(item, quantity)
      if @order.payment_status == "paid"
        item.decrement!(:stock_quantity, quantity)
      else
        item.increment!(:stock_quantity, quantity)
      end
    end
  
    def payment_status_changed?
      @order.saved_change_to_payment_status?
    end
  
    def paid_or_cancelled?
      @order.payment_status == "paid" || @order.payment_status == "cancelled"
    end
  end
  