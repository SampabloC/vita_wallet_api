require 'swagger_helper'

RSpec.describe 'api/user_balances', type: :request do

  path '/api/user_balances/update' do

    post('update user_balance') do
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
