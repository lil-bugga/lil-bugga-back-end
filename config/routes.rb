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
      post 'projects/:project_id/tickets', to: 'tickets#create'

      #Auth
      post 'users/signup', to: 'users#signup'
      post 'users/signin', to: 'users#signin'
    end
    namespace :v1 do
      concerns :base_api
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
