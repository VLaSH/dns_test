class LocationsController < ApplicationController
  respond_to :js, only: :create

  def create
    @location = Geokit::Geocoders::MultiGeocoder.geocode(params[:location][:address])
    respond_with @location, layout: false
  end
end
