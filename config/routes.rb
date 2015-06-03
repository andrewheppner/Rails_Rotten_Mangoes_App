RottenMangoes::Application.routes.draw do

  root 'movies#index'

  resources :movies do 
    resources :reviews, only: [:new, :create]
  end

  resources :users, only: [:new, :create]

  resources :sessions, only: [:new, :create, :destroy]

  namespace :admin do 
    resources :users, only: [:index, :show, :new, :edit, :update, :destroy]
    root 'users#index'
  end

end
 
