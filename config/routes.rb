Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    post 'vote', on: :member
    delete 'unvote', on: :member
    resources :answers do
      patch 'best', on: :member
      post 'vote', on: :member
      delete 'unvote', on: :member
    end
  end
  resources :attachments, only: [:destroy]

  root 'questions#index'
end
