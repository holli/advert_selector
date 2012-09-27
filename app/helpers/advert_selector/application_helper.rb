module AdvertSelector
  module ApplicationHelper

    def advert_selector_initialize
      Rails.logger.tagged('AdvertSelector') do

        Rails.logger.debug("AdvertSelection initialized")

        @advert_selector_banners_selected = []

        advert_selector_banners.each do |banner|
          advert_selector_banner_try(banner)
        end

        Rails.logger.debug("AdvertSelection finished")
        #"AdvertSelector.initialize finished"
      end
      ""
    end

    def advert_selector_banner_try(banner)

      if banner.show_now_basics? &&
          advert_selector_placement_free?(banner.placement) &&
          advert_selector_placement_once_per_session_ok?(banner.placement) &&
          advert_selector_banner_frequency_ok?(banner)

        banner.all_helper_items.each do |hi|
          if hi.content_for?
            content_for hi.name_sym, hi.content.html_safe
          else
            return unless send("advert_selector_#{hi.name}", hi)
          end
        end

        advert_selector_placement_once_per_session_shown(banner.placement)
        advert_selector_banner_frequency_shown(banner)
        banner.add_one_viewcount

        @advert_selector_banners_selected.push(banner)

        Rails.logger.info("Showing banner #{banner.name} in placement #{banner.placement.name}")
      end

    rescue => e
      begin
        # todo: exception catcher here, log to rails cache and display in the main page
        str = "Error with #{banner.name} in placement #{banner.placement.name}.\n#{Time.now.iso8601} - #{request.url} - #{params.inspect}\n#{e.inspect}\n\n#{e.backtrace.first(10).join("\n")}"
        Rails.logger.error(str)
      rescue => e
        Rails.logger.error("ERROR INSIDE ERROR with #{banner.name} in placement #{banner.placement.name} : #{e.inspect}")
      end
    end

    def advert_selector_placement_free?(placement)
      !placement.conflicting_with?(@advert_selector_banners_selected.collect{|b| b.placement.name_sym})
    end

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

    def advert_selector_banner_frequency_cookie(banner)
      val, time = cookies["ad_#{banner.id}"].to_s.split(",")
      [val.to_i, time]
    end
    def advert_selector_banner_frequency_ok?(banner)
      !banner.has_frequency? || advert_selector_banner_frequency_cookie(banner).first < banner.frequency
    end
    def advert_selector_banner_frequency_shown(banner)
      return true unless banner.has_frequency?

      val, time = advert_selector_banner_frequency_cookie(banner)
      time = time.blank? ? 1.week.from_now : Time.parse(time)
      val += 1
      cookies["ad_#{banner.id}"] = {:domain => :all, :expires => time, :value => [val, time.iso8601].join(",") }
    end


    ##########################################################

    def advert_selector_request_params_include?(placement)
      key, val = placement.content.to_s.split("=")
      return params[key] == val
    end


    ##########################################################

    $advert_selector_banners = []
    $advert_selector_banners_load_time = nil
    def advert_selector_banners
      if $advert_selector_banners_load_time.nil? || $advert_selector_banners_load_time < 10.minutes.ago || Rails.env.development?
        Rails.logger.info("AdvertSelection fetching banners and placements")
        $advert_selector_banners_load_time = Time.now

        $advert_selector_banners = Banner.find_current
      end

      $advert_selector_banners
    end

  end
end
