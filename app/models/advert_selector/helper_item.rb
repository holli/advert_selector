module AdvertSelector
  class HelperItem < ActiveRecord::Base
    attr_accessible :master_id, :master_type, :name, :position, :content_for, :content

    #belongs_to :master, :polymorphic => true
    #acts_as_list :scope => [:master_id, :master_type]

    belongs_to :banner, :class_name => 'AdvertSelector::Banner'
    acts_as_list :scope => :banner_id


    def name_sym
      @name_sym ||= name.downcase.to_sym
    end

    def blank?
      name.blank?
    end

  end
end
