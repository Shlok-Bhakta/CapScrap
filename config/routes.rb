Rails.application.routes.draw do
  namespace :admin do
    get "dashboard/users"
    get "dashboard/items"
    get "dashboard/renting"
    get "dashboard/purchased"
    post "dashboard/update_user_role"
    post "dashboard/create_item"
    patch "dashboard/update_item"
    delete "dashboard/delete_item"

    # scope "dashboard" do
    #   resources :items, only: [ :create, :update, :destroy ], controller: :dashboard
    #   post "items", to: "dashboard#create_item"
    #   patch "items/:id", to: "dashboard#update_item"
    #   delete "items/:id", to: "dashboard#delete_item"
    # end
  end
  # Defines the root path route ("/")
  root "items#index"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  resources :purchases
  resources :rentings
  resources :roles
  resources :items
  resources :categories
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
