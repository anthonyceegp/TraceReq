Rails.application.routes.draw do
  resources :projects do
    resources :demands
  end
  
  devise_for :users, controllers: {confirmations: "confirmations"}

  as :user do
    patch "/confirm" => "confirmations#confirm"
  end

  resources :relationships
  resources :relationship_types
  resources :artifacts
  resources :artifact_types
  resources :users
  
  root to: 'home#index'
end
