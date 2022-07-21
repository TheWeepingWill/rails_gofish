Rails.application.routes.draw do
  get 'users/new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#new"



  get '/styleguide', to: 'styleguide#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :games
  get '/play_game/:id', to: 'games#show', as: 'play_game'
  get '/create_game', to: 'games#new'

  get '/create_game_user/:id', to: 'game_users#create', as: 'create_game_user'
  # post '/create_game_user', to: 'game_users#create'
  resources :users
end
