require 'test/test_helper'

module AdvertSelector
  class BannerTest < ActiveSupport::TestCase
    fixtures :all

    setup do
      $advert_selector_avoid_cache = true
    end

    test 'find_future && find_current scopes' do
      assert_equal 2, Banner.find_future.size
      assert_equal 2, Banner.find_current.size

      Timecop.travel( 1.year.ago ) do
        assert_equal 2, Banner.find_future.size
        assert_equal 0, Banner.find_current.size
      end

    end

    test "name_sym" do
      assert_equal :coke, @coke.name_sym
    end

    test "running_viewcount & add_one_viewcount" do
      $advert_selector_avoid_cache = false
      @coke.reset_cache
      @coke[:running_view_count] = 0
      @coke.save

      assert_equal 0, @coke.running_view_count
      @coke.add_one_viewcount
      @coke.add_one_viewcount
      assert_equal 2, @coke.running_view_count

      coke_second = Banner.find(@coke)
      assert_equal 0, coke_second[:running_view_count], "should not save value to db after every reload"
      assert_equal 2, coke_second.running_view_count, "should fetch value from rails cache in every view"

      Rails.cache.write(@coke.cache_key, 1000, :expires_in => 2.weeks)
      @coke.add_one_viewcount

      coke_third = Banner.find(@coke)
      assert_equal 1001, coke_third[:running_view_count], "should have saved value to db after so many views"
    end

    test "view_count_per_day" do
      @coke.update_attributes!(:start_time => Time.now.at_beginning_of_day, :end_time => 10.days.from_now.at_beginning_of_day,
                               :target_view_count => 100)
      @coke.running_view_count = 0
      @coke.save!

      assert @coke.show_today_has_viewcounts?

      @coke.reload
      @coke.running_view_count = 13
      assert !@coke.show_today_has_viewcounts?, "daily limit should be full"

      @coke.fast_mode = true
      assert @coke.show_today_has_viewcounts?, "fast_mode true, always true"
      @coke.fast_mode = false


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
