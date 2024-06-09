class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :store
  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items

  validates :total, presence: true, numericality: {greater_than_or_equal_to: 0}

  enum status: {pending: 0, processing: 1, confirmed: 2, en_route: 3, ready_for_pickup: 4}
  validates :status, presence: true

  enum payment_status: {unsettled: 0, paid: 1, cancelled: 2}
  validates :payment_status, presence: true

  after_update :adjust_stock

  def calculate_total
    OrderTotalCalculatorService.new(self).calculate
  end

  def update_status(new_status)
    OrderStatusUpdaterService.new(self).call(new_status)
  end

  def update_payment_status(new_status)
    OrderPaymentStatusUpdaterService.new(self).call(new_status)
  end

  private

  def adjust_stock
    InventoryAdjustmentService.new(self).call
  end

  #   def minimum_stock_quantity_alert
  #     InventoryAlertService.new(self).call
  #   end
end
