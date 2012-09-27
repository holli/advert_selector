$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "advert_selector/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "advert_selector"
  s.version     = AdvertSelector::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of AdvertSelector."
  s.description = "TODO: Description of AdvertSelector."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "jquery-rails"
  s.add_dependency 'simple_form'

  #s.add_development_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry"
#  s.add_development_dependency "mocha"
  s.add_development_dependency "timecop"

end
