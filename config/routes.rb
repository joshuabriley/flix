Rails.application.routes.draw do
  resources :genres
  root 'movies#index'

  resources :movies do
    resources :reviews
    resources :favorites, only: [:create, :destroy]
  end

  get 'movies/filter/:filter', to: 'movies#index', as: 'filtered_movies'

  resource :session, only: [:new, :create, :destroy]
  get 'signin' => 'sessions#new'
  resources :users
  get 'signup' => 'users#new'
end
