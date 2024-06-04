class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :store
  has_many :order_items
  has_many :items, through: :order_items
  validates :total, :status, presence: true, numericality: { greater_than_or_equal_to: 0 }

  STATUS = ["pending", "processing", "confirmed", "en_route", "ready_for_pickup"]
  validates :status, inclusion: { in: STATUS }

  def process_items
    if self.status == "pending"
      self.update(status: "processing")
    else
      raise "O pedido não pôde ser separado, pois não está pendente!"
    end
  end

  def confirm_items
    if self.status == "processing"
      self.update(status: "confirmed")
    else
      raise "O pedido não pôde ser confirmado, pois não foi separado!"
    end
  end

  def ship_order
    if self.status == "confirmed"
      self.update(status: "en_route")
    else
      raise "O pedido não pôde ser colocado em rota de entrega, pois não foi confirmado!"
    end
  end

  def make_ready_for_pickup
    if self.status == "confirmed"
      self.update(status: "ready_for_pickup")
    else
      raise "O pedido não está disponível para ser colocado para retirada, pois não foi confirmado!"
    end
  end
end
