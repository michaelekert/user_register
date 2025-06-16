Rails.application.routes.draw do
  resources :users, only: [:create]
  get 'users/confirm', to: 'users#confirm', as: :confirm_users
end
