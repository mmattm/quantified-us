require 'resque/server'

Rails.application.routes.draw do

  devise_for :users, controllers: { sessions: 'sessions', registrations: 'registrations', :omniauth_callbacks => "users/omniauth_callbacks" }
  #devise_for :users do get '/users/sign_out' => 'devise/sessions#destroy'
  #get '/users/sign_in'

  devise_scope :user do
    authenticated :user do
      root :to => 'users#dashboard'
    end
    unauthenticated :user do
      #root :to => 'welcome#index', as: :unauthenticated_root
      root :to => 'users/sessions#new', as: :unauthenticated_root
    end
  end


  #authenticate
  authenticate :user do

    resources :users, only: [:show, :index]
    resources :relationships, only: [:create, :destroy, :index]
    resources :circles, only: [:index, :show, :new, :create, :destroy]
    resources :maps, only: [:show, :index, :new, :create, :destroy]
    resources :comments, only: [:create]
    resources :trackers, only: [:index, :show]

    # Additional routes
    get '/dashboard', to: 'users#dashboard', as: 'dashboard'
    get '/settings', to: 'users#settings', as: 'settings'

    # Singular routes
    get 'sync_datas', to: 'users#sync_datas', :as => :sync_datas

    get 'users/:id/followers', to: 'relationships#followers', :as => :followers
    get 'users/:id/following', to: 'relationships#following', :as => :following
    get 'circles/new/metrics', to: 'circles#new_stp2'
    get 'circles/new/participants', to: 'circles#new_stp3'

    get 'maps/new/metrics', to: 'maps#new_stp2'
    get 'maps/new/location', to: 'maps#new_stp3'


    #API
    namespace :api do
      namespace :v1 do
        jsonapi_resources :data_objs
        jsonapi_resources :users, only: [:index, :show]
        jsonapi_resources :comments
      end
    end
  end

  resources :services, only: [:index]
  mount Resque::Server.new, at: "/resque"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #root 'user#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
