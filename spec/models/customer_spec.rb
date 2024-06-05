require 'rails_helper'

RSpec.describe Customer, type: :model do
  context "associations" do
    it 'has_many :orders' do
      expect(Customer.reflect_on_association(:orders)).to_not be nil
    end
    it 'has_many :carts' do
      expect(Customer.reflect_on_association(:carts)).to_not be nil
    end
  end
  context "validations" do
    it 'validate presence of name' do
      customer = Customer.create(email: "teste@teste.com", address: "Rua das Flores, 123")
      expect(customer).to_not be_valid
      expect(customer.errors[:name]).to include("can't be blank")
    end

    it 'validate presence of email' do
      customer = Customer.create(name: 'Teste', address: 'Rua das Flores, 123')
      expect(customer).not_to be_valid
      expect(customer.errors[:email]).to include("can't be blank")
    end

    it 'validate presence of address' do
      customer = Customer.create(name: 'Teste', email: 'Rua das Flores, 123')
      expect(customer).not_to be_valid
      expect(customer.errors[:address]).to include("can't be blank")
    end

    it 'validate uniqueness of email' do
      existing_customer = Customer.create(email: 'teste@teste.com', name: 'Teste', address: 'Rua das Rosas, 456')
      new_customer = Customer.create(name: 'Teste', email: 'teste@teste.com', address: 'Rua das Flores, 123')
      expect(new_customer).not_to be_valid
      expect(new_customer.errors[:email]).to include('has already been taken')
    end

    it 'validate format of email' do
      customer = Customer.create(name: 'Test', email: 'invalid_email', address: 'Rua das Flores, 123')
      expect(customer).not_to be_valid
      expect(customer.errors[:email]).to include('is invalid')
    end
  end
end
