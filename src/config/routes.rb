Rails.application.routes.draw do
  root 'static_pages#home'
  devise_for :users
  get '/contact', to: 'static_pages#contact'
  resources :search_results, only: [:new, :create]
end
