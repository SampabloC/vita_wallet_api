class BtcExchangeRate < ApplicationRecord
  validates :code, presence: true
  validates :symbol, presence: true

  has_many :transactions_as_send_currency, class_name: 'Transaction', foreign_key: 'currency_to_send_id'
  has_many :transactions_as_receive_currency, class_name: 'Transaction', foreign_key: 'currency_to_receive_id'
end
