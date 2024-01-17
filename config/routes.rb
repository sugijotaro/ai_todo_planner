Rails.application.routes.draw do
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
