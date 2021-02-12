Rails.application.routes.draw do
  root to: 'toppages#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'

  resources :users, except: [:new] do
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

  resources :books, except: [:index] do
    member do
      get :book
    end
    collection do
      get :search
    end
  end

  resources :comments, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
end
