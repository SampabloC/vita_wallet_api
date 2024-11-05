class Api::UserBalancesController < ApplicationController
  def update
    ActiveRecord::Base.transaction do
      user = User.find_by(id: params[:user_id])

      if user.present?
        amount = params[:amount].to_f
        withdraw = params[:withdraw]

        current_balance = user.user_balance.usd
        if withdraw == 'true'
          raise 'Not enough money' if current_balance < amount

          current_balance -= amount
        else
          current_balance += amount
        end
        if user.user_balance.update(usd: current_balance)
          render json: {
            message: 'Balance updated',
            balance: user.user_balance
          }, status: :ok
        end
      end
    end
  end
end
