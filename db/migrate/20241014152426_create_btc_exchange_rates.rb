class CreateBtcExchangeRates < ActiveRecord::Migration[7.1]
  def change
    create_table :btc_exchange_rates do |t|
      t.string :code, null: false
      t.string :symbol, null: false
      t.decimal :rate, default: 0
      t.string :description

      t.timestamps
    end
  end
end
