module AdvertSelector
  class ApplicationController < ActionController::Base

    before_action :admin_access_only
    before_action :set_time_zone
    before_action :set_locale

    def admin_access_only
      if AdvertSelector.admin_access_class.send(:admin_access, self)
        return true
      else
        render :plain => "Forbidden, only for admins", :status => 403
        return false
      end
    end

    def set_time_zone
      Time.zone = AdvertSelector.default_time_zone
    end

    def set_locale
      I18n.locale = :en
    end

  end
end
