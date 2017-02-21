Rails.application.routes.draw do
  resources :projects do
    get "/like", to: "likes#create", as: "like"
  end
  devise_for :users
  root to: 'pages#home'

  resources :teams, only: [:show, :create, :new]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
