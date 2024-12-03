Rails.application.routes.draw do
  devise_for :users

  root 'home#index'

  get 'dashboard', to: 'dashboard#index'

  resources :problems, only: [:index] do
    resources :submissions, only: [:new, :create, :show]
  end

  resources :submissions, only: [:show]

  namespace :admin do
    resources :problems
    resources :weeks
    resources :users
  end
end

