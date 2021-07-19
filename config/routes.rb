Rails.application.routes.draw do
  namespace :api do
    concern :base_api do
      # resources :entries
      # resources :tickets
      
      #Projects
      get 'projects',        to: 'projects#index'
      get 'projects/:id',    to: 'projects#show'
      post 'projects',       to: 'projects#create'
      patch 'projects/:id',  to: 'projects#update'
      delete 'projects/:id', to: 'projects#destroy'

      # Tickets
      get 'tickets/all',                        to: 'tickets#index_all'
      get 'tickets/user',                       to: 'tickets#index_user'
      get 'projects/:project_id/tickets',       to: 'tickets#index'
      get 'projects/:project_id/tickets/:id',   to: 'tickets#show'
      post 'projects/:project_id/tickets',      to: 'tickets#create'
      patch 'projects/:project_id/tickets/:id', to: 'tickets#update'
      delete 'projects/:project_id/tickets/:id', to: 'tickets#destroy'

      # Entries
      get 'projects/:project_id/tickets/:ticket_id/entries',       to: 'entries#index'
      get 'projects/:project_id/tickets/:ticket_id/entries/:id',   to: 'entries#show'
      post 'projects/:project_id/tickets/:ticket_id/entries',      to: 'entries#create'
      patch 'projects/:project_id/tickets/:ticket_id/entries/:id', to: 'entries#update'
      delete 'projects/:project_id/tickets/:ticket_id/entries/:id', to: 'entries#destroy'

      #Auth
      post 'users/signup', to: 'users#signup'
      post 'users/signin', to: 'users#signin'
      post 'users/update', to: 'users#update'
    end
    namespace :v1 do
      concerns :base_api
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
