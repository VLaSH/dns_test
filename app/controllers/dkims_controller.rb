class DkimsController < ApplicationController
  def show; end
  
  def create
    dkim_service.call
  end

  private
  def dkim_service
    @dkim_service ||= DKIMService.new(*dkim_service_params)
  end

  def dkim_service_params
    params.require(:dkim).permit(:domain_name, :selector).values
  end
end
