Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  # resources :courses do
  #   get :units, on: :member
  #   get :lessons, on: :member
  #   get :chatrooms, on: :member
  # end

  namespace :admin do
    resources :users, only: [:index] do
      member do
        patch :toggle_instructor
      end
    end
  end

  resources :system_messages, only: %i[show edit update]

  resources :courses, shallow: true do
    resources :units
  end

  resources :units, shallow: true do
    resources :lessons
  end

  resources :lessons, shallow: true do
    resources :chatrooms
  end

  resources :chatrooms do
    resources :messages, only: :create
  end

  resources :messages, only: %i[index show] do
    collection do
      get :export
    end
  end

  resources :settings, only: %i[index create update]

end
