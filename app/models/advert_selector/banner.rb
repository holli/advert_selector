module AdvertSelector
  class Banner < ActiveRecord::Base
    #attr_accessible :comment, :confirmed, :start_time, :end_time,
    #                :frequency, :name, :placement_id, :target_view_count, :priority,
    #                :fast_mode, :helper_items_attributes

    belongs_to :placement, :inverse_of => :banners

    has_many :helper_items, -> { order(:position) }, :dependent => :destroy, inverse_of: :banner
    accepts_nested_attributes_for :helper_items

    scope :find_future, lambda {
      order('priority desc').
          where('end_time > ? OR end_time IS NULL', Time.now).
          includes(:placement, :helper_items)
    }
    scope :find_current, lambda {
      find_future.
          where('start_time < ? OR start_time IS NULL', 1.hour.from_now).
          where('target_view_count IS NULL OR target_view_count > running_view_count')
    }

    # todo validates
    # validate placement

    def name_sym
      @name_sym ||= name.downcase.to_sym
    end

    def has_frequency?
      !frequency.nil? && frequency > 0
    end

    def show_today_has_viewcounts?(current_view_count = nil)
      return true if target_view_count.nil?

      current_view_count = running_view_count if current_view_count.nil?

      return false if current_view_count >= target_view_count
      return true if fast_mode?

      @show_now_today_target ||=
          if target_view_count.nil? || end_time.nil? || end_time < 24.hours.from_now
            true
          else
            total_hours = ((end_time - start_time - 12.hours)/1.hour).round
            hourly_view_count = target_view_count/total_hours

            hours_ending_now = ((Time.now.end_of_hour - start_time)/1.hour).ceil
            hours_ending_now * hourly_view_count
          end

      @show_now_today_target == true || current_view_count < @show_now_today_target
    end

    def show_now_basics?(use_time_limits = true)
      confirmed? &&
        (!use_time_limits || start_time.nil? || start_time < Time.now) &&
        (!use_time_limits || end_time.nil? || Time.now < end_time) &&
        show_today_has_viewcounts?
    end

    def reload
      super
      reset_cache
    end

    def cache_key
      "AdvertSelectorBanner_#{id}"
    end

    def running_view_count
      counter = Rails.cache.read(cache_key).to_i
      counter = 0 if defined?($advert_selector_avoid_cache) && $advert_selector_avoid_cache
      counter = self[:running_view_count] if counter < self[:running_view_count]
      counter
    end

    def reset_cache
      Rails.cache.write(cache_key, nil, :expires_in => 2.weeks)
      @show_now_today_target = nil
      @name_sym = nil
    end

    def add_one_viewcount
      unless self.target_view_count.nil?

        counter = running_view_count + 1
        Rails.cache.write(cache_key, counter, :expires_in => 2.weeks)
        self[:running_view_count] = counter

        since_update = running_view_count_change.last - running_view_count_change.first
        self.save if since_update >= 500 || counter >= target_view_count
      end
    end

    after_save :after_save_destroy_empty_helpers
    def after_save_destroy_empty_helpers
      helper_items.each do |hi|
        hi.destroy if hi.blank?
      end
    end

  end

end
