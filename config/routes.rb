Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers do
      patch 'best', on: :member
    end
  end
  resources :attachments

  root 'questions#index'
end
