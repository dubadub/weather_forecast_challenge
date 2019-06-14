source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"

# Server
gem "rails", "~> 6.0.0.rc1"
gem "puma", "~> 3.11"

# Database
gem "pg", ">= 0.18", "< 2.0"

# ActiveRecord

# Controller
gem "yajl-ruby"

# Frontend
gem "sass-rails", "~> 5"
gem "webpacker", "~> 4.0"
gem "slim"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false


group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails", git: "https://github.com/rspec/rspec-rails", branch: "4-0-dev"
  gem "rspec-core", git: "https://github.com/rspec/rspec-core"
  gem "rspec-mocks", git: "https://github.com/rspec/rspec-mocks"
  gem "rspec-support", git: "https://github.com/rspec/rspec-support"
  gem "rspec-expectations", git: "https://github.com/rspec/rspec-expectations"
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
