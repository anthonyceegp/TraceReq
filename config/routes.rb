Rails.application.routes.draw do
  resources :projects do
    resources :demands do
      resources :artifacts
      resources :relationships
    end
  end
  
  devise_for :users, controllers: {confirmations: "confirmations"}

  as :user do
    patch "/confirm" => "confirmations#confirm"
  end

  resources :relationship_types
  resources :artifact_types
  resources :users
  
  root to: 'home#index'

  get '/projects/:id/users', to: 'projects#users', as: :project_users
  get '/projects/:id/add_users', to: 'projects#add_users', as: :project_add_users
  post '/projects/:id/add_users', to: 'projects#save_add_users'
  post '/projects/:id/users/:user_id', to:'projects#remove_user', as: :project_remove_user

  get '/projects/:project_id/demands/:id/import', to: 'demands#import', as: :import_artifacts
  post '/projects/:project_id/demands/:id/import', to: 'demands#save_import'

  post '/projects/:project_id/demands/:id/remove_artifact/:artifact_id', to: 'demands#remove_artifact', as: :remove_artifact
  get '/projects/:project_id/demands/:demand_id/matrix', to: 'relationships#matrix', as: :matrix
end
