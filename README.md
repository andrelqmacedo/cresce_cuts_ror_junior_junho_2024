## *E-commerce Backend Application*

Esta é uma aplicação backend de um ecommerce, com CRUD completo para Loja, Cliente, Pedido, Item e Carrinho, manipulável via console do Rails, referente ao desafio prático para vaga de Desenvolvedor Ruby on Rails Júnior.

## *Pré-requisitos*

- Ruby 3.3.0
- Rails 7.1.3
- PostgreSQL

## *Instalação*

### 1. Clone o repositório:
    
    git clone -b andre_luiz_queiroga_macedo https://github.com/andrelqmacedo/cresce_cuts_ror_junior_junho_2024.git
    cd cresce_cuts_ror_junior_junho_2024

### 2. Instale as dependências:
    
    bundle install
    
### 3. Configure o banco de dados:

    rails db:create
    rails db:migrate

### 4. Popule o banco de dados com dados iniciais:

    rails db:seed

## *Manipulando Dados via Rails Console*

### 1. Inicie o console:

    rails console 
    
### 2. CRUD para Loja:
    
    loja = Store.create(name: "Nome da Loja", description: "Descrição da loja", address: "Endereço da Loja" ) # Cria loja
    loja1 = Store.find(1)
    puts loja1.name # Lê e exibe o nome da loja com ID 1
    loja1.update(name: "Novo nome da loja") # Atualiza o nome da loja com ID 1
    p loja1.name # Demonstra a atualização do nome da loja
    loja1.destroy # Deleta a loja com ID 1
    
### 3. CRUD para Cliente:

    
    cliente = Customer.create(name: "Stanislau Roberto", email: "sroberto@gmai.com", address: "Rua do Meio, n. 889") # Cria cliente
    p cliente # Lê e exibe os detalhes do cliente 
    cliente.update(email: "stanislaur@gmail.com") # Atualiza o e-mail do cliente 
    cliente.destroy # Deleta o cliente 
    
### 4. CRUD para Item:
    
    item = Item.create(name: 'Produto Exemplo', description: "Um produto usado como exemplo", price: 99.90, stock_quantity: 10) # Cria item
    p item
    puts item.price # Lê e exibe o preço do item 
    item.update(price: 110.99) # Atualiza o preço do item 
    item.destroy # Deleta o item 
    
### 5. CRUD para Carrinho de Compras:
    
    carrinho = Cart.create(customer_id: 1) # Cria carrinho de compras para o cliente com ID 1
    puts carrinho.customer_id # Lê e exibe o ID do cliente associado ao carrinho 
    carrinho.update(customer_id: 2) # Atualiza o ID do cliente associado ao carrinho 
    carrinho.destroy # Deleta o carrinho 
    
### 6.CRUD para Pedido:
#### Obs: Para criar o pedido, precisamos que exista uma instância de cliente e uma de loja.´
    
    pedido = Order.create(customer: cliente, store: loja, total: 0.0, status: "pending", payment_status: "unsettled") #Cria pedido
    p pedido # Lê e exibe os detalhes do pedido
    pedido.update(payment_status: "paid") # Atualiza o status do pagamento do pedido para "pago". 
    # OBS: Essa manipulação é melhor feita através do método próprio para isso, como será demonstrado adiante.
    pedido.destroy # Deleta o pedido
    
## *Manipulando o Fluxo de Status do Pedido via Rails Console*

### 1. Dentro do Rails Console, e com o pedido criado (como visto no ponto 6 do tópico anterior), podemos alterar o status do pedido de "pendente" ("pending" - status do pedido quando criado) para "em separação" ("processing"):
    
    pedido = Order.first
    pedido.update_status("processing")
    
### 2. Em seguida, para alterar o status do pedido de "em separação" ("processing") para "confirmado" ("confirmed"), utilizamos o mesmo método:
    
    pedido.update_status("confirmed")
      
#### O método #update_status irá confirmar, através do serviço de atualização do status do pedido (OrderStatusUpdaterService) se todos os itens estão presentes (isto é, se a quantidade de cada item de pedido é maior do que zero) para em seguida alterar o status do pedido. Caso algum item do pedido não esteja presente, uma mensagem de erro será disparada.

### 3. Para alterar o status do pedido de "confirmado" ("confirmed") para "em rota" ("en_route") ou "disponível para retirada" ("ready_for_pickup"), primeiro devemos alterar o status do pagamento do pedido:
    
    pedido.update_payment_status("paid")

#### OBS: Quando o status de pagamento do pedido for alterado para pago ("paid") a quantidade de estoque daquele item será decrementada na quantidade de itens do pedido.
    
### 4. Uma vez que o status do pagamento do pedido tenha sido alterado para pago ("paid"), será possível escolher se o status do pedido será alterado para "em rota"("en_route") ou "disponível para retirada"("ready_for_pickup")::
    
    pedido.update_status("en_route")
    #ou
    pedido.update_status("ready_for_pickup")

## *Rodando testes da aplicação*

### Para rodar todos os testes da aplicação, devemos rodar o seguinte comando na raiz do projeto:

    rspec

### Ou rodar os testes separadamente:

    rspec spec/models/order_spec.rb # Roda os testes referente ao modelo de Pedido

