Rails.application.routes.draw do
  namespace :api do
    concern :base_api do
      # resources :entries
      # resources :tickets
      # resources :projects
      post 'users/signup', to: 'users#signup'
      post 'users/signin', to: 'users#signin'
    end
    namespace :v1 do
      concerns :base_api
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
