module AdvertSelector
  class Banner < ActiveRecord::Base
    attr_accessible :comment, :confirmed, :start_time, :end_time,
                    :frequency, :name, :placement_id, :target_view_count, :priority,
                    :fast_mode, :helper_items_attributes

    belongs_to :placement, :inverse_of => :banners

    has_many :helper_items, :as => :master, :order => "position", :dependent => :destroy
    accepts_nested_attributes_for :helper_items

    # validate placement

    def name_sym
      @name_sym ||= name.downcase.to_sym
    end

    def view_count_per_day
      @view_count_per_day ||=
          if !end_time.nil? && !start_time.nil? && !target_view_count.nil?
            days_total = ((end_time - start_time)/1.day).ceil
            target_view_count / days_total
          else
            nil
          end
    end

    def show_now_basics?
      view_count = running_view_count

      basics = confirmed? &&
          (start_time.nil? || start_time < Time.now) &&
          (end_time.nil? || Time.now < end_time) &&
          (target_view_count.nil? || view_count < target_view_count) &&
          (view_count_per_day.nil? || view_count < ((Time.now - start_time)/1.day).ceil * view_count_per_day)
    end

    def cache_key
      "AdvertSelectorBanner_#{id}"
    end

    def running_view_count
      counter = Rails.cache.read(cache_key).to_i
      counter = self[:running_view_count] if counter < self[:running_view_count]
      counter
    end

    def add_one_viewcount
      unless self.target_view_count.nil?

        counter = running_view_count + 1
        Rails.cache.write(cache_key, counter, :expires_in => 2.weeks)
        self[:running_view_count] = counter

        since_update = running_view_count_change.last - running_view_count_change.first
        self.save if since_update >= 500
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
