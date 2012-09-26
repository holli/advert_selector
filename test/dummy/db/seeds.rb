
# This is example data for application


leaderboard = AdvertSelector::Placement.create!(
    :name => 'leaderboard'
)

videolayer = AdvertSelector::Placement.create!(
    :name => 'videolayer',
    :request_delay => 10
)

default_basic = leaderboard.banners.create!(
    :name => 'default_basic',
    :start_time => nil,
    :end_time => nil,
    :priority => 1,
    :comment => 'basic default banner',
    :confirmed => true
)

default_basic.helper_items.create!(
    :name => 'banner_leaderboard',
    :content_for => true,
    :content => "basic_banner_content_from_db"
)

priority = leaderboard.banners.create!(
    :name => 'priority',
    :start_time => Time.now.at_midnight,
    :end_time => 10.days.from_now.at_midnight,
    :target_view_count => 1000,
    :fast_mode => false,
    :priority => 100,
    :comment => 'priority banner',
    :confirmed => true
)

priority.helper_items.create!(
    :name => 'request_params_include?',
    :content_for => false,
    :content => 'priority=true'
)

priority.helper_items.create!(
    :name => 'banner_leaderboard',
    :content_for => true,
    :content => 'PRIORITY_banner_content_from_db'
)


