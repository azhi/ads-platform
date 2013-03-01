AdsPlatfrom::Application.routes.draw do
  devise_for :users

  resources :users, :only => [:show]
  resources :advertisements do
    post 'transfer_state', :on => :member
  end

  namespace :admin do
    resources :users, :except => [:show] do
      post 'set_role', :on => :member
    end
    resources :types, :except => [:show]
    match "/review_ads", :to => "advertisements#all_new"
    root :to => "pages#home"
  end

  root :to => "advertisements#index"
end
