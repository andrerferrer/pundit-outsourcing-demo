Rails.application.routes.draw do
  devise_for :users
  root to: 'bookings#index'
  resources :offers, only: %i[ index show ] do
    resources :bookings, only: :create
  end
  resources :bookings, only: %i[ index ]
end
