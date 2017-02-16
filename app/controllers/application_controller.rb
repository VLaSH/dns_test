class ApplicationController < ActionController::Base
  before_action :redirect_to_dashboard
  protect_from_forgery with: :exception

  def redirect_to_dashboard
    if params[:action] == 'show' && params[:controller] != 'dashboards'
      redirect_to root_path
    end
  end
end
