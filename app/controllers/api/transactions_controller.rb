class Api::TransactionsController < ApplicationController
  include Currencies
  def index
    puts params
    transactions = Transaction.all
    render json: transactions
  end

  def create
    update_currencies
    user = User.find_by(id: params[:user_id])
    currencies_used_to_buy = %w[usd eur gbp]

    ActiveRecord::Base.transaction do
      if user.present?
        details = ''
        transaction_complete = false
        amount_received = 0
        amount_to_send = params[:transaction][:amount_to_send]
        transaction = Transaction.new(transaction_params)
        balance = user.user_balance
        currency = BtcExchangeRate.find_by(id: params[:transaction][:currency_to_use_id])
        currency_to_receive = BtcExchangeRate.find_by(id: params[:transaction][:currency_to_receive_id])
        code = currency&.code&.downcase
        code_to_receive = currency_to_receive&.code&.downcase
        if balance[code].nil? || balance[code_to_receive].nil?
          details = 'Verify currencies to send or receive'
        elsif balance[code] < amount_to_send
          details = 'Not enough balance to complete transaction'
        else
          amount = amount_to_send
          amount_received = if currencies_used_to_buy.include?(code) # buy btc
                              (amount / currency.rate)
                            else # sell btc
                              (amount * currency_to_receive.rate)
                            end
          puts amount
          puts amount_received
          puts code
          puts currency.rate
          increase = balance[code_to_receive] + amount_received
          decrease = balance[code] - amount
          puts increase
          puts decrease
          balance.update("#{code}": decrease, "#{code_to_receive}": increase)
          details = "Transaction from #{currency.code} to #{currency_to_receive.code} completed succesfully."
          transaction_complete = true
        end

        transaction.amount_received = amount_received
        transaction.transaction_complete = transaction_complete
        transaction.details = details
        transaction.user_id = params[:user_id]

        if transaction.save
          render json: {
            message: 'Transaction completed',
            data: transaction,
            balance: balance
          }, status: :ok
        else
          render json: {
            message: 'Error saving transaction, verify data.'
          }, status: :bad_request
        end

      end
    end
  end

  def user_history
    user_id = params[:user_id]
    transactions = Transaction.where(user_id: user_id).order(created_at: :desc)

    render json: {
      user_id: user_id,
      transactions: transactions
    }
  end

  private

  def transaction_params
    params.require(:transaction).permit(:currency_to_use_id, :currency_to_receive_id, :amount_to_send)
  end
end
