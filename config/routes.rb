Rails.application.routes.draw do

  resources :projects do
    resources :artifact_types
    resources :artifact_statuses
    resources :relationship_types
    resources :artifacts do
      resources :comments
    end
    resources :relationships
    resources :relationship_types
    resources :templates

    resources :demands do
      resources :artifacts do
        resources :comments
      end
      resources :relationships    
    end
  end
  
  devise_for :users, controllers: {confirmations: "confirmations", registrations: "registrations"}

  as :user do
    patch "/confirm" => "confirmations#confirm"
    get 'users/:id/edit' => 'registrations#edit', :as => 'edit_user_registration'
    put 'users/:id/edit' => 'registrations#update', :as => 'update_user_registration'

    unauthenticated do
      root to: redirect('users/sign_in')
    end
  end

  root to: redirect('/projects')

  resources :users

  get '/users/:id/profile', to: 'users#profile', as: :user_profile
  post '/users/:id/delete_user_avatar', to: 'users#delete_user_avatar', as: :delete_user_avatar
  post '/users/:id/restore', to: 'users#restore', as: :restore_user

  get  '/projects/:id/users', to: 'projects#users', as: :project_users
  get  '/projects/:id/add_users', to: 'projects#add_users', as: :project_add_users
  post '/projects/:id/add_users', to: 'projects#save_add_users'
  post '/projects/:id/users/:user_id', to:'projects#remove_user', as: :project_remove_user
  get  '/projects/:id/status', to: 'projects#status', as: :status_project

  post '/projects/:project_id/artifacts/destroy_artifacts', to: 'artifacts#destroy_artifacts'
  post '/projects/:project_id/artifacts/remove_artifacts', to: 'artifacts#remove_artifacts'
  get  '/projects/:project_id/artifacts/:id/history', to: 'artifacts#history'
  get  '/projects/:project_id/artifacts/:id/demands', to: 'artifacts#demands'
  post '/projects/:project_id/artifacts/:id/delete_file', to: 'artifacts#delete_file'
  post '/projects/:project_id/artifacts/:id/history', to: 'artifacts#remove_revert'
  get '/projects/:project_id/artifacts/:id/show_previous_version/:index', to: 'artifacts#show_previous_version'

  post '/projects/:project_id/relationships/filter', to: 'relationships#filter'

  get  '/projects/:project_id/demands/:id/import', to: 'demands#import', as: :import_artifacts
  post '/projects/:project_id/demands/:id/import', to: 'demands#save_import'

  post '/projects/:project_id/demands/:id/remove_artifact/:artifact_id', to: 'demands#remove_artifact', as: :remove_artifact
  get  '/projects/:project_id/demands/:id/conflict', to: 'demands#conflict', as: :conflict_demand
  post '/projects/:project_id/demands/:id/conflict', to: 'demands#resolve_conflicts'
  get  '/projects/:project_id/demands/:id/status', to: 'demands#status', as: :status_demand

  post '/projects/:project_id/demands/:demand_id/artifacts/destroy_artifacts', to: 'artifacts#destroy_artifacts'
  post '/projects/:project_id/demands/:demand_id/artifacts/remove_artifacts', to: 'artifacts#remove_artifacts'
  get  '/projects/:project_id/demands/:demand_id/artifacts/:id/demands', to: 'artifacts#demands', as: :artifact_demands
  get  '/projects/:project_id/demands/:demand_id/artifacts/:id/history', to: 'artifacts#history', as: :artifact_history
  post '/projects/:project_id/demands/:demand_id/artifacts/:id/history', to: 'artifacts#remove_revert'
  post '/projects/:project_id/demands/:demand_id/artifacts/:id/delete_file', to: 'artifacts#delete_file'
  post '/projects/:project_id/demands/:demand_id/artifacts/:id/import', to: 'artifacts#import'

  post '/projects/:project_id/demands/:demand_id/relationships/filter', to: 'relationships#filter', as: :filter
end
