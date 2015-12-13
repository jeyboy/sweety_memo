Rails.application.routes.draw do
  devise_for :users

  resource :home, controller: 'home'
  resources :gallery_items, only: [:index]
  resources :posts, only: [:index, :show]
  resources :topics, only: [:index, :show]
  resources :categories, only: [:index, :show]

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
