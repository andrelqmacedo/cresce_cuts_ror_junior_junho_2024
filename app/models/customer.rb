class Customer < ApplicationRecord
  has_many :orders
  has_many :carts
  validates :name, :email, :address, presence: true
  validates :email, uniqueness: true
end
