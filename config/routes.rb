Rails.application.routes.draw do
  devise_for :users

  root 'home#index'

  get 'dashboard', to: 'dashboard#index'

  resources :problems, only: [:index] do
    resources :submissions, only: [:new, :create, :show]
  end

  resources :submissions, only: [:show]
end