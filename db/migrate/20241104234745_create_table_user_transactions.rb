class CreateTableUserTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :table_user_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :transactions, null: false, foreign_key: true

      t.timestamps
    end
  end
end
