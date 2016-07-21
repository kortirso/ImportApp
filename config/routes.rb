Rails.application.routes.draw do
    resources :tasks, only: [:index, :show, :create]
    post 'operation' => 'operations#create', as: 'export'
    root 'tasks#index'
end
