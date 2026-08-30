source "https://rubygems.org"

# Declare your gem's dependencies in advert_selector.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
# gem "jquery-rails"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

#gem 'pry'
gem 'timecop'
gem 'mocha', :require => false
gem 'rails-controller-testing'
gem 'sprockets-rails'

gem "minitest", "~> 5.25"
gem "sqlite3", "~> 2.1"

# Test against a specific Rails minor:  RAILS_VERSION=7.2 bundle install
rails_version = ENV["RAILS_VERSION"]
if rails_version
  gem "rails", "~> #{rails_version}.0"
else
  gem "rails"
end

