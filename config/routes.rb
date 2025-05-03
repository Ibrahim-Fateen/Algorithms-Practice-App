Rails.application.routes.draw do
  devise_for :users,
             path: 'users',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'sessions',
                registrations: 'registrations'
             },
             defaults: { format: :json }

  get 'winners', to: 'winners#index'

  unauthenticated do
    root to: 'home#index', as: :unauthenticated_root
  end

  authenticated do
    root to: 'dashboard#index'

    # Dashboard
    get 'dashboard', to: 'dashboard#index'

    # Weeks
    resources :weeks, only: [:index, :show]

    # Problems
    resources :problems, only: [:index, :show] do
      # Nested submissions for specific problem context
      resources :submissions, only: [:create]
    end

    # Submissions (for viewing individual submissions)
    resources :submissions, only: [:index, :show]

    # Users
    resources :users, only: [:index, :show]

    # Admin namespace
    namespace :admin do
      # Problem management
      resources :problems, only: [:index, :create, :update, :destroy, :edit]

      # Week management with publishing capability
      resources :weeks do
        member do
          patch :publish
        end
        collection do
          get :upcoming
          get :past
        end
      end

      # User management (admin-specific actions)
      resources :users, only: [:index, :show, :new, :create, :destroy] do
        member do
          patch :make_admin
        end
      end
    end
  end
end
