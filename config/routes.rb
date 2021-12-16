Rails.application.routes.draw do
  # devise_for :user_auths
  namespace :api do
    namespace :v1 do
      post 'signin', to: 'sessions#create' 
      post 'signup/learner', to: 'learners#create' 
      post 'signup/admin', to: 'admins#create' 
      post 'signup/instructor', to: 'instructors#create' 
      get 'user', to: 'sessions#current_user' 
    end
  end
end
