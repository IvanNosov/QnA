Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  get 'confirm/:link', to: 'users#confirm', as: 'confirm'
  post 'send_confirmation', to: 'users#send_confirmation'

  resources :questions do
    post 'vote', on: :member
    delete 'unvote', on: :member
    post :comment, on: :member
    resources :answers do
      patch 'best', on: :member
      post 'vote', on: :member
      delete 'unvote', on: :member
      post :comment, on: :member
    end
  end
  resources :attachments, only: [:destroy]

  root 'questions#index'

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :all
      end
      resources :questions, only: :index
    end
  end

  mount ActionCable.server => '/cable'
end
