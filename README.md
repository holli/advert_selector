# AdvertSelector

Rails adserver tool for selecting a smaller subset of banners from all
possible banners with differing banner placement combinations. Gem
includes admin tools for handling banners in live
environment. Includes basic targeting, viewcount, frequency etc
setups.

Good for deciding e.g. what height of header banner you will have
during the initial requests without extra javascript calls to
adserver. This helps to avoid problems of browser not knowing what
size of banner there is and enables browser to render the whole page
faster.

[<img src="https://secure.travis-ci.org/holli/advert_selector.png" />](http://travis-ci.org/holli/advert_selector)

## Features

- selecting small subset of (advert) banners from multiple banners
  - banners can be also be any kind of widgets
- defining banners
  - setting filters to banners in a rails friendly way
- defining placements
  - setting conflicting placements
  - setting filters for placements
- admin tools
  - editing everything
  - testing banners before setting it to live env
  - showing information in banner testing
  - showing error log if there is a problem in banner filters

## Install

```
in /gemfile
  gem 'advert_selector'

# Run following
# bundle
# bundle exec rake railties:install:migrations
# rake db:migrate

in top of views/layouts/your_layout
  <% advert_selector_initialize(:all) %>
  and if you want testing info then at the bottom
  <%= advert_selector_force_test_infos %>

set to somewhere in your layout e.g.
  <%= content_for :banner_header %>

in config/routes
  mount AdvertSelector::Engine => "/advert_selector"

test the admin tool in url
  http://localhost:3000/advert_selector/

If you have problems, try to install simple_form again by setting `gem simple_form` to .Gemfile.

```

## Configuration


```
set extra_configuration in /config/initializers/advert_selector.rb


AdvertSelector.default_banner_test_url = "http://yourdomain.com/?"
self.default_time_zone = 'Helsinki'

class AdminAccessToGemTools
  def self.admin_access(controller)
    if !controller.session[:admin_logged].blank? || Rails.env.development?
      return true
    else
      return false
    end
  end
end
AdvertSelector.admin_access_class = AdminAccessToGemTools


```


## Trageting / Content / HelperItem

All contents and targetings are done through HelperItem-model.

### For targeting define custom helpers alongside your normal viewhelpers. Start by name advert_selector. E.g

```
module AdvertSelectorHelper
  def advert_selector_targeting_gender?(helper_item)
    params[:gender] == helper_item.content
  end
end

And in banner define HelperItem with name 'targeting_age?' and content 'male'. After that the banner would be shown only with
requests that has param[:gender]='male'.

```

### For displaying banner content

HelperItems that are tagged with content_for are used with content_for method in rails. E.g. HelperItem.name = :banner_header
and then in your views you display results by <%= content_for :banner_header %>

## Inside

Banners are read to ruby processes memory once every 10 minutes from sql database. 
Gem uses Rails.cache to cache viewcount of banners. Viewcount is updated to db once in a while. 

Remember that this is not the real viewcount that more advanced banner handling systems have. Bots e.g. will increase the viewcount number


## Some links you might also consider

- http://www.openx.com/
- http://www.google.com/dfp/info/sb/index.html

## Requirements

Gem has been tested with Ruby 1.9.3, Ruby 2.1 and Rails 3.2.

[<img src="https://secure.travis-ci.org/holli/advert_selector.png" />](http://travis-ci.org/holli/advert_selector)

## Support

Submit suggestions or feature requests as a GitHub Issue or Pull Request. Remember to update tests. Tests are quite extensive.

## Licence

This project rocks and uses MIT-LICENSE.
