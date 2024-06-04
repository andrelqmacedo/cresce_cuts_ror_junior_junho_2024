class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :store
  has_many :order_items
  has_many :items, through: :order_items

  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }

  STATUS = ["pending", "processing", "confirmed", "en_route", "ready_for_pickup"]
  validates :status, presence: true, inclusion: { in: STATUS }

  PAYMENT_STATUS = ["pending", "paid", "cancelled"]
  validates :payment_status, presence: true, inclusion: { in: PAYMENT_STATUS }

  def process_items
    if self.status == "pending"
      self.update(status: "processing")
      puts "A loja aceitou seu pedido! Pedido em separação!"
    else
      raise "O pedido não pôde ser separado, pois não está pendente!"
    end
  end

  def confirm_items
    if self.status == "processing" && all_items_present?
      self.update(status: "confirmed")
      puts "Os itens escolhidos foram separados! Pedido confirmado!"
    else
      raise "O pedido não pôde ser confirmado, pois não foi separado!"
    end
  end

  def ship_order
    order = Order.find(self.id)
    if self.status == "confirmed" && payment_received?
      self.update(status: "en_route")
      puts "Pagamento recebido! O pedido está em rota de entrega!"
    else
      raise "O pedido não pôde ser colocado em rota de entrega, pois não foi confirmado!"
    end
  end

  def make_ready_for_pickup
    order = Order.find(self.id)
    if self.status == "confirmed" && payment_received?
      self.update(status: "ready_for_pickup")
      puts "Pagamento recebido! O pedido está disponível para retirada!"
    else
      raise "O pedido não está disponível para retirada, pois não foi confirmado!"
    end
  end

  # private

  def all_items_present?
    self.order_items.all? { |item| item.present? }
  end

  def payment_received?
    unless payment_status == "paid"
      raise "O pagamento ainda não foi finalizado!"
    end
  end
end
