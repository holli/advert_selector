require 'test/test_helper'
#require 'test_helper'

module AdvertSelector
  class PlacementTest < ActiveSupport::TestCase

    setup do
      @parade = advert_selector_placements(:parade)
      @leaderboard = advert_selector_placements(:leaderboard)
    end

    test "name_sym" do
      assert_equal :parade, @parade.name_sym
    end

    test "conflicting_placements" do
      assert_equal 'leaderboard,video', @parade.conflicting_placements_array
      assert_equal [:parade, :leaderboard, :video], @parade.conflicting_placements
    end

    test "conflicting_placements string handling" do
      arr = Placement.conflicting_placements("a,   b  c,a,d")
      assert_equal [:a,:b,:c,:d], arr
    end

    test "conflicting_with" do
      assert @parade.conflicting_with?(@parade), "should conflict with itself"

      assert @parade.conflicting_placements_array.include?("leaderboard"), "wrong setup"
      assert @parade.conflicting_with?(@leaderboard)

      dummy = Placement.new(:name => 'test1')
      assert !@parade.conflicting_with?([dummy])
      assert @parade.conflicting_with?([dummy, @leaderboard])
    end

    test "conflicting_placements_array=" do
      assert_equal 'leaderboard,video', @parade.conflicting_placements_array
      @parade.conflicting_placements_array = 'video,not_found'
      assert @parade.save

      new_parade = Placement.find(@parade)
      assert_equal [:parade, :not_found, :video], new_parade.conflicting_placements

      new_leaderboard = Placement.find(@leaderboard)
      assert_blank new_leaderboard.conflicting_placements_array
    end

    test "HelperItems" do
      helper_items_count = HelperItem.count
      @parade.helper_items.build
      @parade.helper_items.build(:name => 'content_for_invalid', :content_for => true, :position => 10)
      @parade.helper_items.build(:name => 'some_limit_helper_here', :position => 1)
      assert @parade.save

      placement = Placement.find(@parade)

      assert_equal 2, placement.helper_items.size
      assert_equal helper_items_count+2, HelperItem.count

      assert 'some_limit_helper_here', placement.helper_items.first.name

      assert 'content_for_invalid', placement.helper_items.last.name
      assert !placement.helper_items.last.content_for
    end
  end
end
