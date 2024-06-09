class Customer < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :carts, dependent: :destroy

  validates :name, :email, :address, presence: true

  validates :email, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}
end
