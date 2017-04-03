Myflix::Application.routes.draw do
  root 'pages#front'

  get 'ui(/:action)', controller: 'ui'

  get '/', to: 'sessions#index'
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/home', to: 'categories#index'
  post '/sign_out', to: 'sessions#destroy'

  resources :videos, only: [:show] do
    collection do
      get '/search', to: 'videos#search'
    end
  end

  resources :categories, only: [:show]
  resources :users, only: [:create]
end
