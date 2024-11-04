require 'rails_helper'

RSpec.describe BtcExchangeRate, type: :model do
  describe 'Validations for model' do
    it 'should create a new object with valid attributes' do
      object = BtcExchangeRate.create(code: 'USD', symbol: '$', rate: 49_000.0)
      expect(object).to be_valid
    end

    it 'should not create a new object only with rate' do
      object = BtcExchangeRate.create(rate: 49_000.0)
      expect(object).not_to be_valid
    end
  end
end
