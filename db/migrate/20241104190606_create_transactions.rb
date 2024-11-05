class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :currency_to_use, null: false, foreign_key: { to_table: :btc_exchange_rates }
      t.references :currency_to_receive, null: false, foreign_key: { to_table: :btc_exchange_rates }
      t.decimal :amount_to_send, default: 0, precision: 15, scale: 10
      t.decimal :amount_received, default: 0, precision: 15, scale: 10
      t.boolean :transaction_complete, default: false
      t.string :details

      t.timestamps
    end
  end
end
