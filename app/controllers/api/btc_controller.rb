class Api::BtcController < ApplicationController
  def update_rates
    response = HTTParty.get('https://api.coindesk.com/v1/bpi/currentprice.json')
    return unless response.success?

    prices = response['bpi']
    prices.each do |price|
      currency = BtcExchangeRate.find_by(code: price.first)
      data = price.last
      if currency.present?
        currency.update(rate: data['rate_float'])
      else
        BtcExchangeRate.create(code: price.first, symbol: data['symbol'], rate: data['rate_float'],
                               description: data['description'])
      end
    end
  end

  def current_rate
    rates = BtcExchangeRate.all
    render json: rates
  end
end
