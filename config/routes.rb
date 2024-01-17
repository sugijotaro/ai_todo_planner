Rails.application.routes.draw do
  get 'render/index'
  get "up" => "rails/health#show", as: :rails_health_check
  root "render#index"

  resources :tasks do
    member do
      put :complete
    end
    resources :sub_tasks do
      member do
        put :complete
      end
    end
  end
end
