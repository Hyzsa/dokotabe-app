Rails.application.routes.draw do
  root 'static_pages#home'

  get '/contact', to: 'static_pages#contact'

  post '/search', to: 'searches#search'
  get '/result', to: 'searches#result', as: 'search_result'

  get '/users/edit', to: 'static_pages#home'
  devise_for :users
  devise_scope :user do
    get '/users', to: 'devise/registrations#new'
  end

  resources :search_histories, only: [:show]

  resources :favorites

  get '/settings', to: 'setting_pages#settings'
  get '/settings/unsubscribe', to: 'setting_pages#unsubscribe', as: 'unsubscribe'
end
