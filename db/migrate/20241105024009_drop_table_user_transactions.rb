class DropTableUserTransactions < ActiveRecord::Migration[7.1]
  def change
    drop_table :table_user_transactions
  end
end
