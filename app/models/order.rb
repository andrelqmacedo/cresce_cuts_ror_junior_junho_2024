class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :store
  has_many :order_items
  has_many :items, through: :order_items

  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }

  enum status: { pending: 0, processing: 1, confirmed: 2, en_route: 3, ready_for_pickup: 4 }
  validates :status, presence: true

  enum payment_status: { unsettled: 0, paid: 1, cancelled: 2 }
  validates :payment_status, presence: true

  after_update :adjust_stock, if: :saved_change_to_status?

  def calculate_total
    OrderTotalCalculatorService.new(self).calculate
  end

  def update_status(new_status)
    OrderUpdaterService.new(self).update_status(new_status)
  end

  def update_payment_status(new_status)
    OrderUpdaterService.new(self).update_payment_status(new_status)
  end

  private

  def adjust_stock
    if payment_status_previously_changed? && (saved_change_to_payment_status? && (payment_status == "paid" || payment_status == "cancelled"))
      order_items.each do |order_item|
        item = order_item.item
        if payment_status == "paid"
          item.decrement!(stock_quantity, order_item.quantity)
        elsif payment_status == "cancelled"
          item.increment!(stock_quantity, order_item.quantity)
        end
      end
    end
  end

  def minimum_stock_quantity_alert
    order_items.each do |order_item|
      item = order_item.item
      if item.stock_quantity <= 2
        puts "Alerta: Estoque abaixo do limite mínimo! O item #{item.name} possui apenas #{item.stock_quantity} unidades restantes."
      end
    end
  end

end
