Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    resources :users, only: [ :index, :show, :create ] do
      resources :orders, only: [ :index, :create, :show ]
    end

    resources :orders, only: [] do
      member do
        post :complete
        post :cancel
      end
    end
  end
end
