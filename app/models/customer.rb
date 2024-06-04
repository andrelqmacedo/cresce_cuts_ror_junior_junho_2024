class Customer < ApplicationRecord
  has_many :orders
  has_many :carts
  validates :name, :email, :address, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
end
