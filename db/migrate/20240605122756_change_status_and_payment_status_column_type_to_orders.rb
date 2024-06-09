class ChangeStatusAndPaymentStatusColumnTypeToOrders < ActiveRecord::Migration[7.1]
  def change
    change_column :orders, :status, :integer, using: "status::integer", default: 0, null: false
    change_column :orders, :payment_status, :integer, using: "payment_status::integer", default: 0, null: false
  end
end
