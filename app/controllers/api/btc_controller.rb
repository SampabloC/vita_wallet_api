class Api::BtcController < ApplicationController
  before_action :update_rates
  def update_rates
    response = HTTParty.get('https://api.coindesk.com/v1/bpi/currentprice.json')
    unless response.success?
      Rails.logger.error("Failed to fetch BTC rates: #{response.message}")
      return render json: { error: 'Failed to fetch rates' }, status: :service_unavailable
    end

    prices = response['bpi']
    existing_rates = BtcExchangeRate.where(code: prices.keys).index_by(&:code)

    prices.each do |code, data|
      if existing_rates[code]
        existing_rates[code].update(rate: data['rate_float'])
      else
        BtcExchangeRate.create(code: code, symbol: data['symbol'], rate: data['rate_float'],
                               description: data['description'])
      end
    end
  end

  def current_rate
    rates = BtcExchangeRate.select(:code, :rate)
    render json: rates
  end
end
