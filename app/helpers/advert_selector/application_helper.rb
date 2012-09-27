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

    def advert_selector_banner_try(banner)

      # todo: exception catcher here, log to rails cache and display in the main page

      if banner.show_now_basics? &&
          advert_selector_placement_free?(banner.placement)
          advert_selector_placement_once_per_session_ok?(banner.placement)

        # todo: frequency
        # todo: placement targetings
        # todo: banner_targetings

        banner.helper_items.each do |hi|
          if hi.content_for?
            content_for hi.name_sym, hi.content
          else
            return unless send("advert_selector_#{hi.name}", hi.content)
          end
        end

        advert_selector_placement_once_per_session_shown(banner.placement)
        banner.add_one_viewcount

        @advert_selector_banners_selected.push(banner)
        #todo: set placement delay_request
        #todo: set frequency

        Rails.logger.debug("Showing banner #{banner.name} in placement #{banner.placement.name}")
      end

    end

    def advert_selector_placement_free?(placement)
      !placement.conflicting_with?(@advert_selector_banners_selected.collect{|b| b.placement.name_sym})
    end

    # TODO: test these session things
    def advert_selector_placement_once_per_session_ok?(placement)
      !(  placement.only_once_per_session? && session[:advert_selector_session_shown] &&
          session[:advert_selector_session_shown].include?(placement.name) )
    end
    def advert_selector_placement_once_per_session_shown(placement)
      if placement.only_once_per_session?
        session[:advert_selector_session_shown] = [] if session[:advert_selector_session_shown].nil?
        session[:advert_selector_session_shown].push(placement.name)
      end
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
