class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :store
  has_many :order_items
  has_many :items, through: :order_items
  validates :total, :status, presence: true

  STATUS = ["pending", "processing", "confirmed", "en_route", "ready_for_pickup"]
  validates :status, inclusion: { in: STATUS }
end
