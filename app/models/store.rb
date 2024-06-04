class Store < ApplicationRecord
  has_many :orders
  validates :name, :description, :address, presence:true
  validates :name, length: {minimum:3, maximum:15}
end
