class BtcExchangeRate < ApplicationRecord
  validates :code, presence: true
  validates :symbol, presence: true
end
