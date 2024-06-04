class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :store
  has_many :order_items
  has_many :items, through: :order_items
  validates :total, :status, presence: true

  STATUS = ["pending", "in_separation", "confirmed"]
  validates :status, inclusion: { in: STATUS }
end
