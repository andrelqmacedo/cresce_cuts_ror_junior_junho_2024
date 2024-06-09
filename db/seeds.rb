# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "faker"

def show_spinner(msg_start, msg_end = "Done!")
  spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
  spinner.auto_spin
  yield
  spinner.success("(#{msg_end})")
end

# Criação de lojas
5.times do
  Store.create!(
    name: Faker::Company.name,
    description: Faker::Company.catch_phrase,
    address: Faker::Address.full_address
  )
end

# Criação de clientes
10.times do
  Customer.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    address: Faker::Address.full_address
  )
end

# Criação de items
30.times do
  Item.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Commerce.material,
    price: Faker::Commerce.price,
    stock_quantity: Faker::Number.between(from: 1, to: 100)
  )
end

# Criação de carrinho
Customer.all.each do |customer|
  cart = Cart.create!(customer: customer)
  5.times do
    item = Item.order("RANDOM()").first
    CartItem.create!(
      cart: cart,
      item: item,
      quantity: Faker::Number.between(from: 1, to: 10)
    )
  end
end

# Criação de pedidos
Customer.all.each do |customer|
  store = Store.order("RANDOM()").first
  order = Order.create!(
    customer: customer,
    store: store,
    total: 0,
    status: "pending",
    payment_status: "unsettled"
  )

  3.times do
    item = Item.order("RANDOM()").first
    OrderItem.create!(
      order: order,
      item: item,
      quantity: Faker::Number.between(from: 3, to: 10)
    )
  end

  order.calculate_total
end
