module AdvertSelector
  module ApplicationHelper

    def advert_selector_initialize
      Rails.logger.tagged('AdvertSelector') do

        Rails.logger.debug("AdvertSelection initialized")

        @advert_selector_banners_selected = []

        #return banners_targeting_age?('adult')

        advert_selector_banners.each do |banner|
          advert_selector_banner_try(banner)
        end

        "AdvertSelector.initialize finished"
      end
    end

    #def content_for_placement(name)
    #  #Placement.where(:name => name).first.development_code.html_safe
    #
    #  banner = @advert_selector_banners_selected.find{|b| b.placement.name_sym == name.to_sym}
    #
    #  banner.comment.html_safe unless banner.nil?
    #end

    def advert_selector_banner_try(banner)

      if banner.show_now_basics? &&
          advert_selector_placement_free?(banner.placement)
        # todo: no conflicting placements from
        # todo: placement delay_requests
        # todo: frequency
        # todo: banner_targetings

        banner.helper_items.each do |hi|
          if hi.content_for?
            content_for hi.name_sym, hi.content
          else
            return unless send("advert_selector_#{hi.name}", hi.content)
          end
        end

        banner.add_one_viewcount

        @advert_selector_banners_selected.push(banner)
        #todo: set placement delay_request
        #todo: set frequency

        Rails.logger.debug("Showing banner #{banner.name} in placement #{banner.placement.name}")
      end

    end

    def advert_selector_placement_free?(placement)
      # todo: set conflicting banners handling (e.g. parade vs header_banner)
      !@advert_selector_banners_selected.any?{|banner| banner.placement == placement}
    end

    ##########################################################

    def advert_selector_request_params_include?(content)
      key, val = content.split("=")
      return params[key] == val
    end


    ##########################################################

    $advert_selector_banners = []
    $advert_selector_banners_load_time = nil
    def advert_selector_banners
      if $advert_selector_banners_load_time.nil? || $advert_selector_banners_load_time < 10.minutes.ago || Rails.env.development?
        Rails.logger.info("AdvertSelection fetching banners and placements")
        $advert_selector_banners_load_time = Time.now

        $advert_selector_banners = Banner.order('priority desc').includes(:placement)
        # TODO: Select only current banners
        # confirmed, online time within one hour, available viewcount
      end

      $advert_selector_banners
    end

  end
end
