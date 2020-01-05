Rails.application.routes.draw do
  
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
  
  resources :recipes do
    member do
      patch :release #公開・非公開を決めるカラム
    end
  end
  
  resources :ingredients, only: :create
  
  resources :procedures, only: [:create, :destroy]
  post "procedures/change_after", to: "procedures#change_after"
  post "procedures/change_before", to: "procedures#change_before"

end
