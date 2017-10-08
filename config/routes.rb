Rails.application.routes.draw do
  resources :relationships
  resources :relationship_types
  resources :artifacts
  resources :artifact_types
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
