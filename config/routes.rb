Rails.application.routes.draw do
  root "home#index"

  resource :session, only: %i[new create destroy]
  resource :registration, only: %i[new create]

  resources :prompts do
    member do
      post :fork
    end
    resources :versions, only: :show, controller: "prompt_versions"
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
