class Cart < ApplicationRecord
  belongs_to :customer
  has_many :cart_items, dependent: :destroy
  has_many :items, through: :cart_items
  validates :customer, presence: true
end
