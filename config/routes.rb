Rails.application.routes.draw do

 devise_for :users, controllers: {
        registrations: 'users/registrations'
      }

  root to: 'pages#home'

  resources :teams do
    resources :teammates, only: [ :new, :create, :list ]
    resources :websites do
       resources :projects, only: [ :new, :create ] do
          resources :comments, only: [ :new, :create, :destroy]
        end
      end
  end

  get '/oauth2callback', to: 'application#oauth2callback'

  resources :projects, only: [ :show, :edit, :update, :destroy]
end
