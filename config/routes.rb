Bunjy::Application.routes.draw do
  root :to => "home#index"

  # User Land
  resources :users
  resources :payments, :only => [:index, :show, :new, :create]
  resources :withdrawals, :only => [:index, :show, :new, :create]
  resources :payment_methods
  get '/locked' => 'users#locked'

  # API Land
  namespace :api do
    namespace :v1 do
      resources :users
      resources :payments
      resources :payment_methods
      resources :withdrawals
    end
    match 'v:api/*path', :to => redirect("/api/v2/%{path}"), via: [:get, :post]
    match '*path', :to => redirect("/api/v2/%{path}"), via: [:get, :post]
  end

  # Mission Control
  get '/mission-control' => 'mission_control#index'
  get '/mission-control/users' => 'mission_control#users'
  get '/mission-control/payments' => 'mission_control#payments'
  get '/mission-control/withdrawals' => 'mission_control#withdrawals'
  get '/mission-control/settings' => 'mission_control#settings'

  # Settings
  get '/settings/edit/:id' => 'settings#edit'
  get '/settings/delete/:id' => 'settings#delete'
  get '/settings/new' => 'settings#new'
  post '/settings/update' => 'settings#update'
  post '/settings' => 'settings#create'

  # Auth
  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
  post '/auth' => 'sessions#create_with_email'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
  get '/reset-password' => 'sessions#recover_password_form'
  post '/reset-password' => 'sessions#recover_password'
end
