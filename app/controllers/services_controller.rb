class ServicesController < ApplicationController
  def index
    @services = ServiceType.all

    @services_provider = []
    @services.each do |service|
      if service.name == 'jawbone' or service.name == 'fitbit'
        @services_provider.push(service.name)
      else
        @services_provider.push('fitbit')
      end

    end
  end

end
