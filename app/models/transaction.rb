class Transaction < ApplicationRecord
  belongs_to :currency_to_use
  belongs_to :currency_to_receive

  has_many :user_transactions
  has_many :users, through: :user_transactions
  belongs_to :currency_to_send, class_name: 'Btcexchangerate', foreign_key: 'currency_to_send_id'
  belongs_to :currency_to_receive, class_name: 'Btcexchangerate', foreign_key: 'currency_to_receive_id'
end
