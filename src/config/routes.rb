Rails.application.routes.draw do
  root 'static_pages#home'

  get '/contact', to: 'static_pages#contact'

  post '/search', to: 'searches#search'
  get '/result', to: 'searches#result', as: 'search_result'

  get '/settings', to: 'setting_pages#settings'
  get '/settings/unsubscribe', to: 'setting_pages#unsubscribe', as: 'unsubscribe'
  get '/settings/user_info_edit', to: 'setting_pages#user_info_edit', as: 'user_info_edit'

  get '/users/edit', to: 'static_pages#home'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    get '/users', to: 'devise/registrations#new'
    post '/users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  resource :search_history, only: [:show]

  resources :favorites, only: [:show, :create, :destroy] do
    resources :memos
  end
end
