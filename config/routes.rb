Rails.application.routes.draw do
  devise_for :users

  root "projects#index"

  resources :projects, shallow: true do
    resources :tables, shallow: true do
      namespace :relationship do
        resources :directs
      end
      resources :columns, controller: "project/table/columns"
      resources :relationships
      resources :scopes
    end
  end
end
