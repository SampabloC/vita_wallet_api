# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_11_04_234745) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "btc_exchange_rates", force: :cascade do |t|
    t.string "code", null: false
    t.string "symbol", null: false
    t.decimal "rate", default: "0.0"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "table_user_transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "transactions_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transactions_id"], name: "index_table_user_transactions_on_transactions_id"
    t.index ["user_id"], name: "index_table_user_transactions_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "currency_to_use_id", null: false
    t.bigint "currency_to_receive_id", null: false
    t.decimal "amount_to_send", precision: 15, scale: 10, default: "0.0"
    t.decimal "amount_received", precision: 15, scale: 10, default: "0.0"
    t.boolean "transaction_complete", default: false
    t.string "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_to_receive_id"], name: "index_transactions_on_currency_to_receive_id"
    t.index ["currency_to_use_id"], name: "index_transactions_on_currency_to_use_id"
  end

  create_table "user_balances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.float "usd", default: 0.0
    t.float "btc", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_balances_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "table_user_transactions", "transactions", column: "transactions_id"
  add_foreign_key "table_user_transactions", "users"
  add_foreign_key "transactions", "btc_exchange_rates", column: "currency_to_receive_id"
  add_foreign_key "transactions", "btc_exchange_rates", column: "currency_to_use_id"
  add_foreign_key "user_balances", "users"
end
