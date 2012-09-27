require 'test/test_helper'

module AdvertSelector
  class BannerTest < ActiveSupport::TestCase
    fixtures :all

    setup do
      @coke = advert_selector_banners(:coke)
      @pepsi = advert_selector_banners(:pepsi)
    end

    test "name_sym" do
      assert_equal :coke, @coke.name_sym
    end

    test "view_count_per_day" do
      @coke.update_attributes!(:start_time => Time.now.at_beginning_of_day, :end_time => 10.days.from_now.at_beginning_of_day,
                               :target_view_count => 100)
      @coke.running_view_count = 0
      @coke.save!

      assert @coke.show_today_has_viewcounts?

      @coke.reload
      @coke.running_view_count = 13
      assert !@coke.show_today_has_viewcounts?

      Timecop.travel( 5.days.from_now.at_midnight + 12.hours ) do
        @coke.reload
        @coke.running_view_count = 30
        assert @coke.show_today_has_viewcounts?
        assert @coke.show_today_has_viewcounts?(30)
        assert !@coke.show_today_has_viewcounts?(60), "should compare with given value"

        @coke.reload
        @coke.running_view_count = 60
        assert !@coke.show_today_has_viewcounts?
      end

      Timecop.travel( 9.days.from_now.at_midnight + 12.hours ) do
        @coke.reload
        assert @coke.show_today_has_viewcounts?(99), "last day should always be true"
      end

      @coke.reload
      assert !@coke.show_today_has_viewcounts?(101), "should be false if viewcount has been achieved"

      @coke.reload
      @coke.target_view_count = nil
      assert @coke.show_today_has_viewcounts?(1), "should be true if no target viewcount"
    end

    test "show_now_basic? for default banners" do
      @coke.confirmed = false
      @coke.save!
      assert !@coke.show_now_basics?, "not confirmed"

      @coke.confirmed = true
      @coke.save!
      assert @coke.show_now_basics?

      @coke.reload
      @coke.running_view_count = 100000000
      assert !@coke.show_now_basics?, "target reached"
    end

    test "HelperItems" do
      helper_items_count = HelperItem.count
      @coke.helper_items.build
      @coke.helper_items.build(:name => 'content_for_invalid', :content_for => true, :position => 10)
      @coke.helper_items.build(:name => 'some_limit_helper_here', :position => 0)
      assert @coke.save

      banner = Banner.find(@coke)

      assert_equal helper_items_count+2, HelperItem.count

      assert 'some_limit_helper_here', banner.helper_items.first.name

      assert 'content_for_invalid', banner.helper_items.last.name
    end


    # test "the truth" do
    #   assert true
    # end
  end
end
