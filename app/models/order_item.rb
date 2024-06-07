class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # after_save :recalculate_order_total
  # after_destroy :recalculate_order_total
  after_commit :recalculate_order_total, on: [:create, :update, :destroy]

  def total
    quantity * item.price
  end

  private

  def recalculate_order_total
    order.calculate_total
  end
end
