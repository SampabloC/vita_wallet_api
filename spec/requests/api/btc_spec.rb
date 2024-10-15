require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Api::BtcController, type: :controller do
  describe 'Get update rates' do
    before do
      stub_request(:get, 'https://api.coindesk.com/v1/bpi/currentprice.json')
        .to_return(status: 200, body: {
          bpi: {
            USD: { rate_float: 50_000.0, symbol: '$', description: 'United States Dollar' },
            EUR: { rate_float: 42_000.0, symbol: '€', description: 'Euro' }
          }
        }.to_json, headers: { 'Content-Type' => 'application/json' })

      BtcExchangeRate.delete_all
    end

    it 'updates existing currency rates' do
      BtcExchangeRate.create(code: 'USD', symbol: '$', rate: 49_000.0)

      expect do
        get :update_rates
      end.to change { BtcExchangeRate.find_by(code: 'USD').rate }.from(49_000.0).to(50_000.0)
    end

    it 'create new currency rate' do
      expect do
        get :update_rates
      end.to change { BtcExchangeRate.count }.by(2)
    end

    it 'does nothing if the Api fails' do
      stub_request(:get, 'https://api.coindesk.com/v1/bpi/currentprice.json')
        .to_return(status: 500)

      rate_count = BtcExchangeRate.count
      get :update_rates

      expect(BtcExchangeRate.count).to eq(rate_count)
    end
  end

  describe 'Get current rates' do
    it 'show json response ' do
      get :current_rate
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end
end
