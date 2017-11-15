Rails.application.routes.draw do
  
  resources :projects do
    resources :artifact_types
    resources :relationship_types

    resources :demands do
      resources :artifacts
      resources :relationships    
    end
  end
  
  devise_for :users, controllers: {confirmations: "confirmations"}

  as :user do
    patch "/confirm" => "confirmations#confirm"
  end

  resources :users
  
  root to: 'home#index'

  get '/projects/:id/users', to: 'projects#users', as: :project_users
  get '/projects/:id/add_users', to: 'projects#add_users', as: :project_add_users
  post '/projects/:id/add_users', to: 'projects#save_add_users'
  post '/projects/:id/users/:user_id', to:'projects#remove_user', as: :project_remove_user
  get '/projects/:id/artifacts', to: 'projects#artifacts', as: :project_artifacts

  get '/projects/:project_id/demands/:id/import', to: 'demands#import', as: :import_artifacts
  post '/projects/:project_id/demands/:id/import', to: 'demands#save_import'

  post '/projects/:project_id/demands/:id/remove_artifact/:artifact_id', to: 'demands#remove_artifact', as: :remove_artifact
  get '/projects/:project_id/demands/:id/conflict', to: 'demands#conflict', as: :conflict_demand
  post '/projects/:project_id/demands/:id/conflict', to: 'demands#resolve_conflicts'
  post '/projects/:project_id/demands/:demand_id/filter', to: 'relationships#filter', as: :filter

  post '/projects/:project_id/demands/:demand_id/artifacts/:id/delete_file', to: 'artifacts#delete_file', as: :delete_file
  post '/projects/:project_id/demands/:demand_id/artifacts/:id/import', to: 'artifacts#import', as: :import
  get '/projects/:project_id/demands/:demand_id/artifacts/:id/versions', to: 'artifacts#versions', as: :artifact_versions
  get '/projects/:project_id/demands/:demand_id/artifacts/:id/history', to: 'artifacts#history', as: :artifact_history
  post '/projects/:project_id/demands/:demand_id/artifacts/:id/reify', to: 'artifacts#reify', as: :artifact_reify
  get '/projects/:project_id/demands/:demand_id/artifacts/:id/demands', to: 'artifacts#demands', as: :artifact_demands
end
