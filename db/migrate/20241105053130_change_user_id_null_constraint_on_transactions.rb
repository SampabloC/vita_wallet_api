class ChangeUserIdNullConstraintOnTransactions < ActiveRecord::Migration[7.1]
  def change
    change_column_null :user_balances, :user_id, true
  end
end
