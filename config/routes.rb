Rails.application.routes.draw do

  get 'procedures/create'

  get 'procedures/update'

  get 'procedures/destroy'

  #avtive_admin用のルート
  ActiveAdmin.routes(self)
  
  root "static_pages#home"
  get "/about", to:"static_pages#about"
  get '/signup', to: "users#new"
  post "/signup", to: "users#create"
  
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  
  resources :users
  
  resources :recipes
  
  resources :ingredients
  
  resources :procedures
end
