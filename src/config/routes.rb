Rails.application.routes.draw do
  root 'static_pages#home'

  get '/contact', to: 'static_pages#contact'

  resources :search_results, only: [:new, :create]

  get '/users/edit', to: 'static_pages#home'
  devise_for :users
  devise_scope :user do
    get '/users', to: 'devise/registrations#new'
  end
end
