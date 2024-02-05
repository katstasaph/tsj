Rails.application.routes.draw do
  resources :reviews
  resources :announcements
  resources :admin, only: [:index]
  resources :songs do
    post "wp"
    resources :reviews, shallow: true
  end
  get "up" => "rails/health#show", as: :rails_health_check
  root "songs#index"

  devise_for :users, :skip => [:registrations] 
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'registration'
  end
  resources :users
  
  namespace :writer do
  end
  
  namespace :editor do
  end
  
  get '/pages/:page', to: 'pages#show', as: 'page'
  post '/admin/reposition' => 'admin#reposition', :as => 'reposition'

  match '/songs/:id/wp' => 'songs#wp', :as => 'wp_song', :via => [:post]
  match '/reviews/:id/move' => 'reviews#move', :as => 'move', :via => [:patch]

  get '*a' => redirect { |p, req| req.flash[:alert] = "Invalid URL."; '/' }, constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage' }
	
end
