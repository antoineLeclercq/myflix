source 'https://rubygems.org'
ruby '2.1.2'

gem 'bcrypt'
gem 'bootstrap-sass', '3.1.1.1'
gem 'bootstrap_form'
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'coffee-rails'
gem 'draper'
gem 'fabrication'
gem 'faker'
gem 'figaro'
gem 'haml-rails'
gem 'jquery-rails'
gem 'mini_magick'
gem 'pg'
gem 'rails', '4.1.1'
gem 'sass-rails'
gem "sentry-raven"
gem 'sidekiq', '4.2.10'
gem 'stripe'
gem 'stripe_event'
gem 'uglifier'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman'
  gem 'letter_opener'
  gem 'thin'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '~> 3.5'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'chromedriver-helper'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 3.0'
  gem 'vcr'
  gem 'webmock'
end

group :development, :staging, :production do
  gem 'puma'
end

group :staging, :production do
  gem 'rails_12factor'
end

