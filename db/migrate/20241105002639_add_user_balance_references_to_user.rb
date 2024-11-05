class AddUserBalanceReferencesToUser < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :user_balance, foreign_key: true
  end
end
