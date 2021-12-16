Rails.application.routes.draw do
  # devise_for :user_auths
  namespace :api do
    namespace :v1 do
      post 'signin', to: 'sessions#create' 
      get 'user', to: 'sessions#current_user' 
    end
  end
end
