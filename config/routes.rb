Rails.application.routes.draw do
  resources :images
  devise_for :users
  resources :posts
  resources :topics
  resource :home, controller: 'home'
  resources :categories

  namespace :panel do
    resource :landing, controller: 'panel/landing'
    resources :categories
    resources :topics
    resources :posts
  end

  get 'panel', to: 'panel/landing#show', as: :panel
  post 'search', to: 'home#search', as: :search

  root 'home#show'
end
