Rails.application.routes.draw do

  devise_for :users, controllers: {
        registrations: 'users/registrations'
      }

  root to: 'pages#home'

  resources :teams, only: [:show, :create, :new] do
    resources :teammates, only: [ :new, :create, :list ]
  end


  resources :projects do
    get "/like", to: "likes#create", as: "like"
    post "/comment", to: "comments#create"
  end
  
  resources :websites

end
