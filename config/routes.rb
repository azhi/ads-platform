AdsPlatfrom::Application.routes.draw do
  resources :advertisements
  resources :types, :except => [:show]

  root :to => "advertisements#index"
end
