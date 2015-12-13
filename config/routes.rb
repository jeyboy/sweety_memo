Rails.application.routes.draw do
  resources :gallery_items
  resources :images
  devise_for :users
  resources :posts
  resources :topics
  resource :home, controller: 'home'
  resources :categories

  authenticated(:user) do
    namespace :panel do
      resource :landing, controller: 'panel/landing'
      resources :categories
      resources :topics
      resources :posts
      resources :gallery_items
    end

    get 'panel', to: 'panel/landing#show', as: :panel
  end

  post 'search', to: 'home#search', as: :search

  root 'home#show'
end
