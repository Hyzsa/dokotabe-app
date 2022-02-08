Rails.application.routes.draw do
  root 'static_pages#home'

  get '/contact', to: 'static_pages#contact'

  resources :search_results, only: [:new, :create]

  resources :search_histories, only: [:show]

  get '/users/edit', to: 'static_pages#home'
  devise_for :users
  devise_scope :user do
    get '/users', to: 'devise/registrations#new'
  end

  get '/settings', to: 'setting_pages#settings'
end
