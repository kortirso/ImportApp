Rails.application.routes.draw do
    resources :tasks, only: [:index, :show, :create]
    post 'operation' => 'operations#create', as: 'export'
    root 'tasks#index'
    match '*path', to: 'application#catch_404', via: :all
end
