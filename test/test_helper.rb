
# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../../test/dummy/config/environment.rb", __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)
require "rails/test_help"
require "mocha/setup"


# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new




# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end



class ActiveSupport::TestCase

  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  setup do

    $advert_selector_banners_load_time = nil # force reload of banners in every tests
    @coke = advert_selector_banners(:coke)
    @pepsi = advert_selector_banners(:pepsi)
    @parade_banner = advert_selector_banners(:parade_banner)

    Timecop.return
    Timecop.travel( Time.now.at_midnight + 12.hours ) unless [6..20].include?(Time.now.hour)
  end

  teardown do
    Timecop.return
    $advert_selector_avoid_cache = false
    @coke.reset_cache
    @pepsi.reset_cache
    @parade_banner.reset_cache
    AdvertSelector::ErrorsCache.clear
  end

end