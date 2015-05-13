require 'acts_as_list'
require 'simple_form'

require "advert_selector/engine"
require "advert_selector/errors_cache"

module AdvertSelector

  mattr_accessor :default_banner_test_url
  mattr_accessor :default_time_zone
  mattr_accessor :admin_access_class

  self.default_banner_test_url = "http://localhost:3000/?"
  self.default_time_zone = 'UTC'

  class AdminAccessClassDefault
    def self.admin_access(controller)
      Rails.env.development?
    end
  end
  class AdminAccessClassAlwaysTrue
    def self.admin_access(controller)
      true
    end
  end

  self.admin_access_class = AdminAccessClassDefault

end
