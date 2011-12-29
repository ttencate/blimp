source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"

gem "redis"
gem "grit", :git => "git://github.com/mojombo/grit.git"
gem 'sinatra'

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "rspec"
  gem "jeweler", "~> 1.6.4"
  gem "rcov", ">= 0"
  gem 'pry'
  gem 'shotgun'
end

group :test do
  gem 'fakefs'
  gem 'mock_redis'
end
