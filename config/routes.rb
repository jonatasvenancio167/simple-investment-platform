Rails.application.routes.draw do
  root "dashboards#index"

  resources :users
  resources :fundraises
  resources :investments
end
