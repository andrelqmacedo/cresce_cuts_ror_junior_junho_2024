class Store < ApplicationRecord
  has_many :orders, dependent: :destroy
  validates :name, :description, :address, presence: true
  validates :name, length: {minimum: 3}
end
