# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    ActiveRecord::Base.transaction do
      build_resource
      resource = User.new(sign_up_params)
      resource.user_balance_id = 1 # temp
      puts resource.inspect
      if resource.save
        usr_balance = create_user_balance(resource)
        resource.update(user_balance_id: usr_balance.id)

        respond_with resource, location: after_sign_up_path_for(resource)
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end
  end

  def create_user_balance(user)
    UserBalance.create(usd: 0, btc: 0, user_id: user.id)
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end

  def respond_with(resource, _opts = {})
    if resource.errors.empty?
      render json: {
        status: { code: 200, message: 'Signed up successfully.' },
        data: resource
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: 'Error signing up.' },
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
end
