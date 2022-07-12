Rails.application.routes.draw do
  get 'users/new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#new"
  get '/hello', to: 'application#hello'
  get '/goodbye', to: 'application#goodbye'
  get '/styleguide', to: 'styleguide#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/index', to: 'games#index'
  get '/play_game', to: 'games#play'
  get '/create_game', to: 'games#create'
  resources :users
end
