AdsPlatfrom::Application.routes.draw do
  devise_for :users

  resources :users
  resources :advertisements
  resources :types, :except => [:show]

  root :to => "users#index"
end
