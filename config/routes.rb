Rails.application.routes.draw do
  devise_for :users

  resource :home, controller: 'home'
  resources :gallery_topics, only: [:index, :show]
  resources :posts, only: [:index, :show]
  resources :topics, only: [:index, :show]
  resources :categories, only: [:index, :show]

  authenticated(:user) do
    namespace :panel do
      resource :landing, controller: 'panel/landing'
      resources :categories
      resources :topics
      resources :posts, content_type: POST_TEXT_CONTENT
      resources :videos, controller: 'posts', content_type: POST_VIDEO_CONTENT
      resources :gallery_items
      resources :gallery_topics do
        get 'unclassified', to: 'gallery_topics#unclassified', on: :collection, as: :unclassified_gallery_items
      end
    end

    get 'panel', to: 'panel/landing#show', as: :panel
  end

  post 'search', to: 'home#search', as: :search

  root 'home#show'
  match '*path' => redirect { |p, req| req.flash[:alert] = 'Aaargh, this path is not exist'; '/' }, via: [:get, :post]
end
