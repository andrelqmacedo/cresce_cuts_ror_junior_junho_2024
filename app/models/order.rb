class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :store
  has_many :order_items
  has_many :items, through: :order_items
  validates :total, :status, presence: true, numericality: { greater_than_or_equal_to: 0 }

  STATUS = ["pending", "processing", "confirmed", "en_route", "ready_for_pickup"]
  validates :status, inclusion: { in: STATUS }

  enum payment_status: { pending: 0, paid: 1, failed: 2}
  validates :payment_status, enum: { pending: 0, paid: 1, failed: 2 }

  def process_items
    if self.status == "pending"
      raise "A loja aceitou seu pedido! Pedido em separação!"
      self.update(status: "processing")
    else
      raise "O pedido não pôde ser separado, pois não está pendente!"
    end
  end

  def confirm_items
    if self.status == "processing" && all_items_present?
      raise "Os itens escolhidos foram separados! Pedido confirmado!"
      self.update(status: "confirmed")
    else
      raise "O pedido não pôde ser confirmado, pois não foi separado!"
    end
  end

  def ship_order
    if self.status == "confirmed" && payment_received?
      raise "Pagamento recebido! O pedido está em rota de entrega!"
      self.update(status: "en_route")
    else
      raise "O pedido não pôde ser colocado em rota de entrega, pois não foi confirmado!"
    end
  end

  def make_ready_for_pickup
    if self.status == "confirmed" && payment_received?
      raise "Pagamento recebido! O pedido está disponível para retirada!"
      self.update(status: "ready_for_pickup")
    else
      raise "O pedido não está disponível para retirada, pois não foi confirmado!"
    end
  end

  private

  def all_items_present?
    self.order_items.all? { |item| item.present? }
  end

  def payment_received?
    unless payment_status == "paid"
      raise "Pagamento não recebido!"
    end
  end
end
