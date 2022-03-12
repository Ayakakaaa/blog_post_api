# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
ruby '2.6.5'
Used NET::HTTP to get api response (no need to add gem for that)
* System dependencies

* Configuration

* How to run the test suite
Added gem 'rspec-rails', '~> 5.0.0' for test
Running specs
# Default: Run all spec files (i.e., those matching spec/**/*_spec.rb)
$ bundle exec rspec

# Run all spec files in a single directory (recursively)
$ bundle exec rspec spec/models

# Run a single spec file
$ bundle exec rspec spec/controllers/accounts_controller_spec.rb

# Run a single example from a spec file (by line number)
$ bundle exec rspec spec/controllers/accounts_controller_spec.rb:8

# See all options for running specs
$ bundle exec rspec --help
* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
