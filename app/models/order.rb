class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :store
  has_many :order_items
  has_many :items, through: :order_items

  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }

  enum status: { pending: 0, processing: 1, confirmed: 2, en_route: 3, ready_for_pickup: 4 }
  validates :status, presence: true

  enum payment_status: { unsettled: 0, paid: 1, cancelled: 2 }
  validates :payment_status, presence: true

  after_update :adjust_stock, if: :saved_change_to_status?

  def calculate_total
    total = order_items.sum(&:total)
    update(total: total)
  end

  def update_status(new_status)
    update(status: new_status)
    case new_status
    when "processing"
      puts "A loja aceitou seu pedido! Pedido em separação!"
    when "confirmed"
      if all_items_present?
        puts "Os itens escolhidos foram separados! Pedido confirmado!"
      else
        raise "O pedido não pôde ser confirmado, pois não foi separado!"
      end
    when "en_route"
      if payment_status == "paid"
        puts "Pagamento recebido! O pedido está em rota de entrega!"
      else
        raise "O pedido não pôde ser colocado em rota de entrega, pois não foi confirmado!"
      end
    when "ready_for_pickup"
      if payment_status == "paid"
        puts "Pagamento recebido! O pedido está disponível para retirada!"
      else
        raise "O pedido não está disponível para retirada, pois não foi confirmado!"
      end
    end
  end

  private

  def adjust_stock
    if status_previously_changed? && (saved_change_to_status? && (status == "paid" || status == "cancelled"))
      order_items.each do |order_item|
        item = order_item.item
        if status == "paid"
          item.decrement!(:stock_quantity, order_item.quantity)
        elsif status == "cancelled"
          item.increment!(:stock_quantity, order_item.quantity)
        end
      end
    end
  end

  def all_items_present?
    order_items.all? { |item| item.present? }
  end
end
