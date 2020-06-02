Rails.application.routes.draw do
  root to: 'offers#index'
  resources :offers, only: %i[ index ]
end
