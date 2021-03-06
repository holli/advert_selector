require File.dirname(__FILE__) + '/../../test_helper'

module AdvertSelector
  class BannerTest < ActiveSupport::TestCase
    # fixtures :all

    setup do
      $advert_selector_avoid_cache = true
    end

    test 'find_future && find_current scopes' do
      #binding.pry
      assert_equal 3, Banner.find_future.size
      assert_equal 3, Banner.find_current.size

      Timecop.travel( 1.year.ago ) do
        assert_equal 3, Banner.find_future.size
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

      coke_second = Banner.find(@coke.id)
      assert_equal 0, coke_second[:running_view_count], "should not save value to db after every reload"
      assert_equal 2, coke_second.running_view_count, "should fetch value from rails cache in every view"

      Rails.cache.write(@coke.cache_key, 550, :expires_in => 2.weeks)
      @coke.add_one_viewcount

      coke_third = Banner.find(@coke.id)
      assert_equal 551, coke_third[:running_view_count], "should have saved value to db after so many views"
    end

    test "running_viewcount & add_one_viewcount reaching target" do
      $advert_selector_avoid_cache = false
      @coke.reset_cache
      @coke[:running_view_count] = 0
      @coke.target_view_count = 10
      @coke.save

      assert_equal 0, @coke.running_view_count
      Rails.cache.write(@coke.cache_key, @coke.target_view_count-1, :expires_in => 2.weeks)
      @coke.add_one_viewcount
      assert_equal 10, @coke.running_view_count

      coke_second = Banner.find(@coke.id)
      assert_equal 10, coke_second[:running_view_count], "should save if reaching target"
    end

    test "view_count per_hour" do

      start_time = Time.now.at_beginning_of_day

      # 10 views per hour
      @coke.update(:start_time => start_time, :end_time => start_time + 112.hours,
                               :target_view_count => 1000, :fast_mode => false)
      @coke.running_view_count = 0
      @coke.save!

      Timecop.travel( start_time + 4.5.hours  )
      assert @coke.show_today_has_viewcounts?

      @coke.reload
      @coke.running_view_count = 39
      assert @coke.show_today_has_viewcounts?

      @coke.reload
      @coke.running_view_count = 49
      assert @coke.show_today_has_viewcounts?

      @coke.reload
      @coke.running_view_count = 51
      assert !@coke.show_today_has_viewcounts?

      Timecop.travel( start_time + 90.hours )
      @coke.reload
      @coke.running_view_count = 990
      assert @coke.show_today_has_viewcounts?, "should let last 24h to display everything straight away"

    end

    test "view_count basics compare_value and per_fast_mode" do
      start_time = Time.now.at_beginning_of_day

      # 10 views per hour
      @coke.update(:start_time => start_time, :end_time => start_time + 112.hours,
                               :target_view_count => 1000, :fast_mode => false)
      @coke.running_view_count = 0
      @coke.save!

      Timecop.travel( start_time + 4.5.hours  )

      assert @coke.show_today_has_viewcounts?
      @coke.reload
      assert !@coke.show_today_has_viewcounts?(900), "use given value in has_viewcounts"

      @coke.reload
      @coke.fast_mode = true
      assert @coke.show_today_has_viewcounts?(900), "true always with fast_mode on"

      @coke.reload
      @coke.fast_mode = true
      assert !@coke.show_today_has_viewcounts?(1010), "should be false if viewcount has been achieved even though in fast mode"

      @coke.reload
      @coke.target_view_count = nil
      assert @coke.show_today_has_viewcounts?(2000), "should be true if no target viewcount"
    end

    test "view_count daily tests" do
      start_time = Time.now.at_beginning_of_day
      @coke.update(:start_time => start_time, :end_time => 10.days.from_now.at_beginning_of_day,
                               :target_view_count => 1000, :fast_mode => false)
      @coke.running_view_count = 0
      @coke.save!

      Timecop.travel( start_time + 11.hours  )

      assert @coke.show_today_has_viewcounts?

      @coke.reload
      @coke.running_view_count = 130
      assert !@coke.show_today_has_viewcounts?, "daily limit should be full"

      @coke.fast_mode = true
      assert @coke.show_today_has_viewcounts?, "fast_mode true, always true"
      @coke.fast_mode = false


      Timecop.travel( 5.days.from_now.at_midnight + 12.hours ) do
        @coke.reload
        @coke.running_view_count = 300
        assert @coke.show_today_has_viewcounts?
        assert @coke.show_today_has_viewcounts?(300)
        assert !@coke.show_today_has_viewcounts?(600), "should compare with given value"

        @coke.reload
        @coke.running_view_count = 600
        assert !@coke.show_today_has_viewcounts?
      end

      Timecop.travel( 9.days.from_now.at_midnight + 12.hours ) do
        @coke.reload
        assert @coke.show_today_has_viewcounts?(990), "last day should always be true"
      end

      @coke.reload
      assert !@coke.show_today_has_viewcounts?(1010), "should be false if viewcount has been achieved"

      @coke.reload
      @coke.target_view_count = nil
      assert @coke.show_today_has_viewcounts?(1000), "should be true if no target viewcount"

      Timecop.travel( start_time + 19.hours ) do
        @coke.reload
        @coke.update(:start_time => start_time + 18.hours, :end_time => 10.days.from_now.at_beginning_of_day,
                               :target_view_count => 1000)
        @coke.running_view_count = 0
        assert @coke.show_today_has_viewcounts?(), "should be true for the first day even if start is later in the evening"        
      end
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

    test "show_now_basic? time usages" do
      assert @coke.show_now_basics?, "setup is wrong"

      @coke.start_time = 1.hour.from_now
      @coke.save!
      assert !@coke.show_now_basics?, "should not display if advert in future"

      @coke.start_time = 2.hour.ago
      @coke.end_time = 1.hour.ago
      @coke.save!
      assert !@coke.show_now_basics?, "should not display if advert in past"

      @coke.start_time = nil
      @coke.end_time = 1.hour.from_now
      @coke.save!
      assert @coke.show_now_basics?, "should display if advert has only end_time in the future"

    end

    test "HelperItems" do
      helper_items_count = HelperItem.count
      @coke.helper_items.build
      @coke.helper_items.build(:name => 'content_for_invalid', :content_for => true, :position => 10)
      @coke.helper_items.build(:name => 'some_limit_helper_here', :position => 0)
      assert @coke.save

      banner = Banner.find(@coke.id)

      assert_equal helper_items_count+2, HelperItem.count

      assert 'some_limit_helper_here', banner.helper_items.first.name

      assert 'content_for_invalid', banner.helper_items.last.name
    end


    # test "the truth" do
    #   assert true
    # end
  end
end
