
# This is example data for application


leaderboard = AdvertSelector::Placement.create!(
    :name => 'leaderboard',
    :development_code => '<img src="http://placehold.it/728x90&text=leaderboard" alt="leaderboard"/>'
)

videolayer = AdvertSelector::Placement.create!(
    :name => 'videolayer',
    :development_code => '<script>alert("Showing videolayer");</script>',
    :request_delay => 10
)

leaderboard.banners.create!(
    :name => 'default_basic',
    :start_time => nil,
    :end_time => nil,
    :priority => 1,
    :comment => 'basic default banner',
    :confirmed => true
)

leaderboard.banners.create!(
    :name => 'priority',
    :start_time => Time.now.at_midnight,
    :end_time => 10.days.from_now.at_midnight,
    :target_view_count => 100,
    :target_view_count => 100,
    :fast_mode => false,
    :priority => 100,
    :comment => 'priority banner',
    :confirmed => true
)
