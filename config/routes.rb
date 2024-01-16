Rails.application.routes.draw do
  resources :tasks do
    resources :sub_tasks, only: [:show, :destroy]
  end
end
