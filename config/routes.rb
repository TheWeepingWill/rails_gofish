Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/hello', to: 'application#hello'
  get '/goodbye', to: 'application#goodbye'
  get '/styleguide', to: 'styleguide#index'

end
