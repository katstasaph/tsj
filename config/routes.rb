Rails.application.routes.draw do
  resources :reviews
  resources :admin, only: [:index]
  resources :songs do
    post "wp"
    resources :reviews, shallow: true
  end
  devise_for :users
  resources :users
  get "up" => "rails/health#show", as: :rails_health_check
  root "songs#index"
  
  namespace :writer do
  end
  
  namespace :editor do
  end
  
  get '/pages/:page', to: 'pages#show', as: 'page'
  match '/songs/:id/wp' => 'songs#wp', :as => 'wp_song', :via => [:post]

  get '*a' => redirect { |p, req| req.flash[:alert] = "Invalid URL."; '/' }, constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage' }
end
