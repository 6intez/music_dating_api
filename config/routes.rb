Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create] do
        collection do
          get 'random'
          get 'matches'
        end
      end
      post 'likes/:id', to: 'likes#create', as: 'like_user'
    end
  end
end