Rails.application.routes.draw do
  root to: 'toppages#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'

  resources :users, only: %i[index show create destroy edit update] do
    member do
      get :followings
      get :followers
      get :will_read
      get :read
    end
    collection do
      get :ranking
    end
  end

  resources :books, only: %i[show create edit update destroy new] do
    member do
      get :book
    end
  end

  resources :comments, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
end
