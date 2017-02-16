class LookupsController < ApplicationController
  def show; end

  def create
    lookup_service.call
  end

  private
  def lookup_service
    @lookup_service ||= DNS::LookupService.new(*lookup_service_params)
  end
  helper_method :lookup_service

  def lookup_service_params
    params.require(:lookup).permit(:address).values
  end
end
