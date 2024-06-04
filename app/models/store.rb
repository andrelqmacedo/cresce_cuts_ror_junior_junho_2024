class Store < ApplicationRecord
  has_many :orders
  validates :name, :description, :address, presence:true
end
