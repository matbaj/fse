Fse::Application.routes.draw do
  devise_for :users
  namespace "admin"  do
    resources :categories,:things
    resources :orders, only: [:index, :show]
    root to: "admin#index"
  end

  resources :things, only: [:show] do
    get "search", on: :collection
  end
  resources :categories, only: [:show] 
  root :to => "shop#index"
  match '/search' => 'shop#search', :via => [:get, :post], :as => :search
  match 'cart_item_add(.:format)' => "shop#cart_item_add"
  match '/spa/:action', :controller => 'spa'
  match '/spa', :controller => 'spa', :action => "index"

  match ':action(/:id)', :controller => 'shop'

  # match ':controller(/:action(/:id))(.:format)'
end
