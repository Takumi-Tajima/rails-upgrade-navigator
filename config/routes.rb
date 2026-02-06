Rails.application.routes.draw do
  root 'repositories#new'
  resources :repositories, only: %i[index show new create] do
    resources :gem_reports, only: %i[show update]
  end
  get 'up' => 'rails/health#show', as: :rails_health_check
end
