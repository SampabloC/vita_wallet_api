require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Api::TransactionsController, type: :controller do
  describe 'get transactions' do
    before do
      create_transaction
    end
    it 'should return a succesful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'should respond with elements' do
      get :index
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe 'GET #user_history' do
    before do
      create_transaction
    end

    it 'returns the transaction history for the specified user' do
      get :user_history, params: { user_id: 1 }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['transactions']).to all(include('user_id' => 1))
    end
  end

  def create_transaction
    currency = BtcExchangeRate.create(code: 'USD', symbol: '$', rate: 49_000.0)
    user_balance = UserBalance.create
    user = User.create(user_balance_id: user_balance.id, email: 'test@test.com', password: 'password123')
    Transaction.create(currency_to_use_id: currency.id, currency_to_receive_id: currency.id, amount_to_send: 100,
                       user_id: user.id)
  end
end
