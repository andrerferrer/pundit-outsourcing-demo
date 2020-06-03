Rails.application.routes.draw do
  get 'bookings/index'
  devise_for :users
  root to: 'offers#index'
  resources :offers, only: %i[ index show ]
end
