class Item < ApplicationRecord
  has_many :order_items
  has_many :cart_items
  validates :name, :description, :price, :stock_quantity, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
