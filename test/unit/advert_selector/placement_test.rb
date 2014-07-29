require File.dirname(__FILE__) + '/../../test_helper'
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
      assert new_leaderboard.conflicting_placements_array.blank?
    end

  end
end
