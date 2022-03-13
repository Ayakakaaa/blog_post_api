require 'net/http'
class PostsController < ApplicationController
  before_action :get_tags_params, only: [:index]
  before_action :get_direction_params
  before_action :get_sortBy_params

  # GET /posts
  def index
    # keep rails from returning status 304
    headers['Last-Modified'] = Time.now.httpdate
    
    posts = fetch_posts_by_tags
    posts = deduplicate_posts posts
    posts = sort_posts posts

    render json: posts, status: 200
  end

  private

  def fetch_posts_by_tag tag
    begin
      uri = URI.parse("https://api.hatchways.io/assessment/blog/posts")
      params = {tag: tag}
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri) 
    rescue StandardError
      render_error "API call with tag '#{tag}' failed"
    end
    result = JSON.parse(res.body)
    if res.is_a?(Net::HTTPSuccess) && result["posts"]
      return result["posts"]
    else 
      render_error "API call with tag '#{tag}' failed"
    end
  end

  def fetch_posts_by_tags
    posts = []
    # pool has as many threads as their are cpu processors
    pool = Concurrent::FixedThreadPool.new(Concurrent.processor_count)
    @tags_params.each do |tag|
      # asking to create a new thread when one becomes available
      pool.post do
        posts_by_tag = fetch_posts_by_tag tag
        posts = posts.concat(posts_by_tag)
      end
    end
    # wait for all the threads to finish before we continue
    pool.shutdown
    pool.wait_for_termination
    
    return posts
  end

  def get_tags_params
    @tags_params = params[:tags]
    if !@tags_params
      render_error "Tags parameter is required"
    else
      @tags_params = @tags_params.split(",")
      #remove duplicate values to avoid unecessary API calls
      @tags_params = @tags_params.uniq
    end
  end

  def get_sortBy_params
    @sortBy_params = params[:sortBy]
    if @sortBy_params
      if !["id","reads","likes", "popularity"].include?(@sortBy_params)
        render_error "sortedBy parameter is invalid"
      end
    else
      # 'id' is default sortBy param
      @sortBy_params = "id"
    end
  end

  def get_direction_params
    @direction_params = params[:direction]
    if @direction_params
      if !["desc", "asc"].include?(@direction_params)
        render_error "direction parameter is invalid"
      end
    else
      # 'asc' is default direction param
      @direction_params = "asc"
    end
  end

  def deduplicate_posts posts
    # remove duplicates
    # ruby implements uniq efficiently using hash
    posts.uniq { |post| post["id"] }
  end

  def sort_posts posts
    if @direction_params == "asc"
      # using ruby's efficient quicksort
      posts.sort { |a,b| a[@sortBy_params] <=> b[@sortBy_params] }
    else 
      # desc
      posts.sort { |a,b| b[@sortBy_params] <=> a[@sortBy_params] }
    end
  end

  def render_error error
    render json: {error: error}, status: 400
  end
end
