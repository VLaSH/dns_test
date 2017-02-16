Rails.application.routes.draw do
  root to: 'dashboards#show'

  resource :dkim
  resource :spf
  resource :lookup
  resource :dashboard
end
