require_dependency "advert_selector/application_controller"

module AdvertSelector
  class MainController < ApplicationController
    def index
    end

    def clear_errors_log
      AdvertSelector::ErrorsCache.clear
      redirect_to :action => :index
    end
  end
end
