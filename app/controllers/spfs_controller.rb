class SpfsController < ApplicationController
  def show; end

  def create
    spf_service.call
  end

  private
  def spf_service
    @spf_service ||= DNS::SPFService.new(*spf_service_params)
  end

  def spf_service_params
    params.require(:spf).permit(:address, :domain_name).values
  end
end
