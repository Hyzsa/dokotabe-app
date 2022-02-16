Rails.application.routes.draw do
  root 'static_pages#home'

  get '/contact', to: 'static_pages#contact'

  post '/search', to: 'searches#search'
  get '/result', to: 'searches#result', as: 'search_result'

  get '/settings', to: 'setting_pages#settings'
  get '/settings/unsubscribe', to: 'setting_pages#unsubscribe', as: 'unsubscribe'

  get '/users/edit', to: 'static_pages#home'
  devise_for :users
  devise_scope :user do
    get '/users', to: 'devise/registrations#new'
  end

  resources :search_histories, only: [:show]
  resource :favorite, only: [:show, :create, :destroy] do
    resources :memos
  end
end
