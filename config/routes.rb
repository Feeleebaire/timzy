Rails.application.routes.draw do

 devise_for :users, controllers: {
        registrations: 'users/registrations'
      }

  root to: 'pages#home'

  resources :teams do
    resources :teammates, only: [ :new, :create ]
    resources :projects, only: [ :new, :create ]
    member do
      get '/authorise', to: 'oauth#authorise'
      get 'set_analytics', to: 'teams#set_analytics'
      patch 'save_analytics', to: 'teams#save_analytics'
    end
  end

  get '/oauth2callback', to: 'oauth#callback'
  get '/feed', to: 'notifications#index'


  resources :projects, only: [ :show, :edit, :update, :destroy] do
       resources :comments, only: [ :new, :create, :destroy]
  end

  resources :comments, only: [ :index, :edit, :update, :destroy]

end
