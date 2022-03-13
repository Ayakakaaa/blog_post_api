# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
ruby '2.6.5'
# Use concurrent-ruby so we can do multiple API calls at a time
gem 'concurrent-ruby', require: 'concurrent'

Used NET::HTTP to get api response (no need to add gem for that)

* Configuration
bundle install

* How to run the test suite
Added gem 'rspec-rails', '~> 5.0.0' for test
Running specs
# Default: Run all spec files (i.e., those matching spec/**/*_spec.rb)
$ bundle exec rspec




