Rails.application.routes.draw do
  resources :projects
  devise_for :users, controllers: {
        registrations: 'users/registrations'
      }
  root to: 'pages#home'

  resources :teams, only: [:show, :create, :new] do
    resources :teammates, only: [ :new, :create, :list ]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
