require 'sidekiq/web'

Myflix::Application.routes.draw do
  root 'pages#front'

  get 'ui(/:action)', controller: 'ui'

  get 'register', to: 'users#new'
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'home', to: 'categories#index'
  post 'sign_out', to: 'sessions#destroy'

  get 'my_queue', to: 'queue_items#index'
  patch 'queue_items', to: 'queue_items#update'

  get 'people', to: 'relationships#index'

  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
      get 'advanced_search', to: 'videos#advanced_search'
    end

    resources :reviews, only: [:create]
  end

  resources :categories, only: [:show]
  resources :users, only: [:create, :show]
  resources :queue_items, only: [:create, :destroy]
  resources :relationships, only: [:destroy, :create]

  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:show, :create]
  get'expired_token', to: 'pages#expired_token'

  resources :invitations, only: [:new, :create]

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end

  mount StripeEvent::Engine, at: '/stripe_events'
  mount Sidekiq::Web => '/sidekiq'
end
