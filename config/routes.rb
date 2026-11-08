Rails.application.routes.draw do
  root "home#index"

  resource :session, only: %i[new create destroy]
  resource :registration, only: %i[new create]
  get "dashboard", to: "dashboard#show", as: :dashboard
  get "favorites", to: "favorites#index", as: :favorites
  resources :users, only: :show

  resources :prompts do
    resource :favorite, only: %i[create destroy], controller: "favorites"
    resources :comments, only: %i[create edit update destroy]
    member do
      post :fork
    end
    resources :versions, only: :show, controller: "prompt_versions" do
      collection { get :compare }
      member { post :restore }
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
