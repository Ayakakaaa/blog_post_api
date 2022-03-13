# README
* Versions
ruby '2.6.5'
rails '6.0.4.7'

* Dependencies
concurrent-ruby to process multiple API calls at a time
rspec-rails '5.0.0' for testing
Used NET::HTTP to get api response (no need to add gem for that)

* Configuration
$ bundle install

* How to run the test suite
$ bundle exec rspec # Default: Run all spec files (i.e., those matching spec/**/*_spec.rb)

# CHECKLIST
* an /api/ping route to return a 200 code and success variable
* an /api/posts route that handles the following query parameters
    * tags (mandatory): any number of comma-separated strings
        * deduplicated tags to reduce load on API
    * sortBy (optional): one of "id", "reads", "likes", "popularity"
        * default: "id"
    * direction (optional): one of "asc", "desc"
        * default: "asc"
* efficient deduplication of posts (using hash method)
* efficient sorting of posts (using quicksort method)
* error handling: return an error message if:
    * tags parameter is missing
    * sortBy has an invalid value
    * direction has an invalid value
    * BONUS - hatchways API returns an error
* testing without using our solution API route


