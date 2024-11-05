Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
                                 sign_in: 'login',
                                 sign_out: 'logout',
                                 registration: 'signup'
                               },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    scope :btc do
      get 'current_rates', to: 'btc#current_rate'
      get 'update_rates', to: 'btc#update_rates'
    end

    scope :transactions do
      get 'index', to: 'transactions#index'
      get 'user_history', to: 'transactions#user_history'
      post 'create', to: 'transactions#create'
    end

    scope :user_balances do
      post 'update', to: 'user_balances#update'
    end
  end
end
