Rails.application.routes.draw do
  resources :projects do
    resources :comments, only: [:create, :destroy]

    #get "/like", to: "likes#create", as: "like"
    #post "/comment", to: "comments#create"
  end

  devise_for :users, controllers: {
        registrations: 'users/registrations'
      }

  root to: 'pages#home'

  resources :teams, only: [:show, :create, :new] do
    resources :teammates, only: [ :new, :create, :list ]
  end

  
  resources :websites

end
