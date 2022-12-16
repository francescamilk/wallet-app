Rails.application.routes.draw do
  root 'pages#home'
  get '/sync',          to: 'pages#sync'
  get 'results/',       to: 'results#index'
  get 'agreements/:id', to: 'agreements#index'
  
  devise_for :users
  resources  :calendars, only: :create do
    collection do
      post :import
    end
  end
end
