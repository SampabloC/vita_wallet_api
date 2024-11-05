class Api::BtcController < ApplicationController
  include Currencies
  before_action :update_rates
  def update_rates
    update_currencies
  end

  def current_rate
    rates = BtcExchangeRate.select(:code, :rate)
    render json: rates
  end
end
