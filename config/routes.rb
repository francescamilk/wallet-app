Rails.application.routes.draw do
  root 'pages#home'
  get  '/sync',    to: 'pages#sync'
  
  devise_for :users
  resources  :calendars, only: :create do
    collection do
      post :import
    end
  end
end
