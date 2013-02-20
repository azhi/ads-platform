AdsPlatfrom::Application.routes.draw do
  devise_for :users

  resources :users, :only => [:show, :index]
  resources :advertisements do
    member do
      post 'transfer_state'
    end
  end

  namespace :admin do
    resources :users, :except => [:show, :index] do
      member do
        post 'set_role'
      end
    end
    resources :types, :except => [:show]
  end

  root :to => "advertisements#index"
end
