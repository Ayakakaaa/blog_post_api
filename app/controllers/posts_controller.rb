require 'net/http'
class PostsController < ApplicationController
    # before_action :get_tags_params, only: [:index]
    # before_action :get_direction_params
    # before_action :get_sortBy_params
    def index
        render json: fetch_posts_bytag, status: 200
    end

    private

    def fetch_posts_bytag
        begin
          uri = URI.parse("https://api.hatchways.io/assessment/blog/posts")
          params = {tag: "tech"}
          uri.query = URI.encode_www_form(params)
          res = Net::HTTP.get_response(uri) 
        rescue StandardError
          false
        end
        if res.is_a?(Net::HTTPSuccess)
          status = 200
          result = res.body
        else 
          status = 400
          result = {error: status}
        end
        result
      end

    

end
