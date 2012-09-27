# AdvertSelector

Tool for selecting a smaller subset of banners from all possible banners with differing banner placement
combinations.


## TODO

- admin työkalu
  - setup banners
    - test banner in live
  - exception logger to cache

- check time usages
  - using local times ???

- banner
  - iffes - banners_targeting_age?('!underage')


## Install

```
in /gemfile
  gem 'advert_selector'

# Run following
# bundle
# bundle exec rake railties:install:migrations FROM=referer_tracking
# rake db:migrate

```

## Configure

```

in views/layouts/your_view
  AdvertSelector.initialize

/config/initializers/advert_selector.rb


```


## Inside

- AdvertSelector.initialize_banners
  - Reads all current banners to shared variable once in 10 minutes
    - avoid initializing banners every time
  - Processes banner settings
    - updates banner_viewcount, saves to sql every 10:th viewcount

- Admin interface
  - Flushes banner cache - not possible at the moment
  - Export info (gets everything in yaml so that you can load those to your own dev machine?)

- Banner
  - name, dates, target_view_count, frequency, delay_requests, comment, confirmed?
  - belongs_to :placement
  - has_many :items

- Placement
  - name [video, parade, parade-other, jättibanneri, vertical, vertical-wide]
  - has_many :default_banners, :as => :content
    - nil for not using in development
  - conflicting_placements_array (:serialize)
  - has_many :items

- HelperItem
  - belongs_to :attachable, :polymorphic => true
  - name 'advert_selector_xxx'
  - position
  - content_for
  - content



## Other

- http://stackoverflow.com/questions/1109145/ad-banner-management-rotation-for-ruby-on-rails
- muita
  - http://www.openx.com/
  - http://www.google.com/dfp/info/sb/index.html

## Support

Submit suggestions or feature requests as a GitHub Issue or Pull Request. Remember to update tests. Tests are quite extensive.

## Licence

This project rocks and uses MIT-LICENSE.
