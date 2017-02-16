Rails.application.routes.draw do
  root to: 'dashboards#show'

  resource :dkim, only: [:show, :new, :create]
  resource :spf, only: [:show, :new, :create]
  resource :lookup, only: [:show, :new, :create]
  resource :dashboard, only: :show
  resource :location, only: [:new, :create]
end
