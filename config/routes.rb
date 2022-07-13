Rails.application.routes.draw do
  get 'users/new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#new"



  get '/styleguide', to: 'styleguide#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/index', to: 'games#index'
  get '/play_game/:id', to: 'games#show', as: 'play_game'
  get '/create_game', to: 'games#new'
  post '/games', to: 'games#create'
  resources :users
  resources :game
end
