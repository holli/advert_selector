module AdvertSelector
  class Placement < ActiveRecord::Base
    attr_accessible :conflicting_placements_array, :development_code, :name, :request_delay

    has_many :banners, :inverse_of => :placement


    def name_sym
      @name_sym ||= name.downcase.to_sym
    end

  end
end
