# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'
  get 'cart/update_user_cart', to: 'cart#update_user_cart'
  get 'welcome/index', to: 'welcome#index'
  get 'products/filter', to: 'products#filter', method: :post
  get 'products/get_quantity', to: 'products#get_quantity'

  resources :product_sizes, only: [:destroy]
  resources :products do
    collection do
      get :stats
      get :reports
      get :filter_by_gender
      get :product_type_for_gender
      get :report_preview
      get :generate_report
      get :product_count
    end
    member do
      get :edit_tag
      patch :update_tag
    end
  end
  resources :user_profiles, only: :show do
    collection do
      get :list_user_orders
    end
    member do
      get :edit_user_image
      post :update_cart
      get :edit_profile
      patch :update_profile
    end
  end
  resources :images, only: %i[update create]
  resources :cart, only: %i[show destroy] do
    member do
      get :summary
    end
  end
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  get 'user/:id', to: 'user_profiles#show'
  resources :orders do
    collection do
      get :update_order_status
    end
  end
  resources :addresses, only: %i[create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :payments
  resources :wishlists
  namespace :api do
    namespace :v1 do
      resources :sessions
      resources :users, only: %i[show]
    end
  end
end
