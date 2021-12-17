# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'signin', to: 'sessions#create'
      post 'signup/learner', to: 'learners#create'
      post 'signup/admin', to: 'admins#create'
      post 'signup/instructor', to: 'instructors#create'
      get 'user', to: 'sessions#current_user'
      post 'user/resetpassword', to: 'sessions#reset'
      put 'user/resetpassword', to: 'sessions#update_password'
    end
  end
end
