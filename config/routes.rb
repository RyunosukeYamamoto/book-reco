Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  
  resources :users, only: [:index, :show, :create, :destroy] do
    member do
      get :followings
      get :followers
      get :will_read
      get :read
    end
  end
  
  resources :books, only: [:show, :create, :edit, :update, :destroy, :new] do
    member do
      get :book
    end
  end
  
  resources :comments, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
end