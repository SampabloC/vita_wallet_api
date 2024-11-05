class CreateUserBalances < ActiveRecord::Migration[7.1]
  def change
    create_table :user_balances do |t|
      t.references :user, null: false, foreign_key: true
      t.float :usd, default: 0
      t.float :btc, default: 0

      t.timestamps
    end
  end
end
