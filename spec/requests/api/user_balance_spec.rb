require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Api::UserBalancesController, type: :controller do
  describe 'update balances' do
    it 'should update balance' do
      user_balance = UserBalance.create(usd: 0, btc: 0)
      user = User.create(user_balance_id: user_balance.id, email: 'test@test.com', password: 'password123')
      params = {
        user_id: user.id,
        amount: 500,
        withdraw: false
      }

      expect do
        post :update, params: params
      end.to change { UserBalance.find_by(id: user_balance.id).usd }.from(0).to(500)
    end

    it 'should not update balances if amount is not enough' do
      user_balance = UserBalance.create(usd: 200, btc: 0)
      user = User.create(user_balance_id: user_balance.id, email: 'test@test.com', password: 'password123')
      params = {
        user_id: user.id,
        amount: 500,
        withdraw: true
      }

      expect do
        post :update, params: params
      end.to raise_error
    end
  end
end
