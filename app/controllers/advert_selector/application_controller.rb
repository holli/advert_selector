module AdvertSelector
  class ApplicationController < ActionController::Base

    before_filter :admin_access_only

    def admin_access_only
      if AdvertSelector.admin_access_class.send(:admin_access, self)
        return true
      else
        render :text => "Forbidden, only for admins", :status => 403
        return false
      end
    end
  end
end
