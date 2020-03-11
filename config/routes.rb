Rails.application.routes.draw do
  
  #avtive_admin用のルート
  ActiveAdmin.routes(self)
  
  root "static_pages#home"
  get "/about", to:"static_pages#about"
  get '/signup', to: "users#new"
  post "/signup", to: "users#create"
  
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/auth/:provider/callback", to: 'sessions#twitter_create'
  delete "/logout", to: "sessions#destroy"
  
  resources :users
  
  resources :recipes do
    member do
      get :liked #レシピをイイネしたユーザーの一覧
      patch :release #公開・非公開を決めるカラム
    end
  end
  
  resources :ingredients, only: :create
  
  resources :procedures, only: :create
  patch "procedures/update", to: "procedures#update"
  delete "procedures/destroy", to: "procedures#destroy"
  post "procedures/change_after", to: "procedures#change_after"
  post "procedures/change_before", to: "procedures#change_before"
  
  resources :likes, only: [:create, :destroy]
  
  resources :books, only: [:create,:destroy]
  
  resources :impressions, only: [:create, :destroy]
end
