module AdvertSelector
  class Engine < ::Rails::Engine
    isolate_namespace AdvertSelector

    config.to_prepare do
      ::ApplicationController.helper(AdvertSelector::ApplicationHelper)
    end

    #initializer 'advert_selector.action_controller' do |app|
    #  ActiveSupport.on_load :action_controller do
    #    helper AdvertSelector::PlacementsHelper
    #  end
    #end
  end
end

#ActionView::Base.send :include, AdvertSelector::PlacementsHelper

