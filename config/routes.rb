Bunjy::Application.routes.draw do
  root :to => "home#index"

  # User Land
  resources :users, :only => [:index, :show, :edit, :update]
  resources :payments, :only => [:index, :show, :new, :create]
  resources :withdrawals, :only => [:index, :show, :new, :create]
  resources :payment_methods

  # Mission Control
  get '/mission-control' => 'mission_control#index'
  get '/mission-control/users' => 'mission_control#users'
  get '/mission-control/payments' => 'mission_control#payments'
  get '/mission-control/withdrawals' => 'mission_control#withdrawals'

  # Auth
  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
end
