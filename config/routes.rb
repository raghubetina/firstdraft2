Rails.application.routes.draw do
  devise_for :users

  root "projects#index"

  resources :projects

  namespace :project do
    resources :tables

    namespace :table do
      namespace :relationship do
        resources :directs
      end
      resources :columns
      resources :relationships
      resources :scopes
    end
  end
end
