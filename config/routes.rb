Rails.application.routes.draw do
  devise_for :users
  root to: 'bookings#index'
  resources :offers, only: %i[ index show ]
  resources :bookigns, only: :index
end
