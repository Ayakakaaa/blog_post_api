require 'net/http'
class PostsController < ApplicationController
    before_action :get_tags_params, only: [:index]
    before_action :get_direction_params
    before_action :get_sortBy_params
    def index
        render json: fetch_posts_bytag, status: 200
    end

    private

    def fetch_posts_bytag tag
        begin
          uri = URI.parse("https://api.hatchways.io/assessment/blog/posts")
          params = {tag: tag}
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

      def get_tags_params
        @tags_params = params[:tags]
        if !@tags_params
          render json: {error: "Tags parameter is required"}, status: 400
        else
          @tags_params = @tags_params.split(",")
          #remove duplicate values
          @tags_params = @tags_params.uniq
          puts @tags_params[0]
        end
      end
    
      def get_sortBy_params
        @sortBy_params = params[:sortBy]
        if @sortBy_params
          if !["id","reads","likes", "popularity"].include?(@sortBy_params)
            render json: {error: "sortedBy parameter is invalid"}, status: 400
          end
        else
          @sortBy_params = "id"
        end
      end
    
      def get_direction_params
        @direction_params = params[:direction]
        if @direction_params
          if !["desc", "asc"].include?(@direction_params)
            render json: {error: "direction parameter is invalid"}, status: 400
          end
        else
          @direction_params = "asc"
        end
      end

    

end
