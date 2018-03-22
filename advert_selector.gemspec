$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "advert_selector/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "advert_selector"
  s.version     = AdvertSelector::VERSION
  s.authors     = ["Olli Huotari"]
  s.email       = ["olli.huotari@iki.fi"]
  s.homepage    = "https://github.com/holli/advert_selector/"
  s.licenses    = ['MIT']
  s.summary     = "Rails adserver tool for selecting a smaller subset of banners from all possible banners with differing banner placement combinations."
  s.description = "Rails adserver tool for selecting a smaller subset of banners from all possible banners with differing banner placement combinations. Gem includes admin tools for handling banners in live environment. Includes basic targeting, viewcount, frequency etc setups."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 5"
  s.add_dependency "simple_form", ">= 3"
  s.add_dependency "acts_as_list", ">= 0.6"

  s.add_dependency "jquery-rails", ">= 3"

  s.add_development_dependency "sqlite3", ">= 1.3"
  #s.add_development_dependency 'rails-controller-testing'
  #s.add_development_dependency "mocha"
  #s.add_development_dependency "timecop"

end
