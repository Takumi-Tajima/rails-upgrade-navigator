Rails.application.routes.draw do
  root 'repositories#new'
  resources :repositories, only: %i[index show new create]
  get 'up' => 'rails/health#show', as: :rails_health_check
end
