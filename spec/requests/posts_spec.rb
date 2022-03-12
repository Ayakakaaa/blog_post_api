require 'rails_helper'

RSpec.describe PostsController do
  describe "Get posts without any params" do
    before do
      get api_posts_path
    end
    it "fails without a tags param" do
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["error"]).to eq("Tags parameter is required")
    end
  end

  describe "Get posts with invalid sortBy param" do 
    before do
      get api_posts_path, params: {sortBy: "rating", tags: "tech"}
    end
    it "fails without an invalid sortBy param" do
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["error"]).to eq("sortedBy parameter is invalid")
    end
  end

  describe "Get posts with invalid direction param" do 
    before do
      get api_posts_path, params: {direction: "sideways", tags: "tech"}
    end
    it "fails without an invalid direction param" do
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["error"]).to eq("direction parameter is invalid")
    end
  end

  describe "Get posts with tags params" do 
    before do
      get api_posts_path, params: {tags: "tech"}
      @posts = JSON.parse(response.body)
    end
    it "succees with tags param" do
      expect(response).to have_http_status(200)
      expect(@posts.count).to be > 0
    end
    it "'tech' tags param only returns posts with selected tag" do
      expect(response).to have_http_status(200)
      @posts.each do |post|
        expect(post["tags"]).to include("tech")
      end
    end
    it "posts are ordered by ascending id if no sortBy and direction parameters are sent" do
      expect(response).to have_http_status(200)

      @posts.each_with_index do |post, index|
        if index < (@posts.count - 1)
          nextPost = @posts[index + 1]
          expect(nextPost["id"]).to be > post["id"]
        end
      end
    end
  end

  describe "Get posts with multiple tags" do 
    before do
      get api_posts_path, params: {tags: "tech,health"}
      @posts = JSON.parse(response.body)
    end
    it "succees with multips tags param" do
      expect(response).to have_http_status(200)
      expect(@posts.count).to be > 0
    end
    it "'tech,health' tags param only returns posts with selected tags" do
      expect(response).to have_http_status(200)
      @posts.each do |post|
        expect(post["tags"].include?("tech") || post["tags"].include?("health")).to be true
      end
    end
    it "'tech,health' tags param doesn't return duplicate posts" do
      expect(response).to have_http_status(200)
      expect(@posts.count).to eq(@posts.uniq { |p| p["id"]}.count)
    end
    it "posts are ordered by ascending id if no sortBy and direction parameters are sent" do
      expect(response).to have_http_status(200)

      @posts.each_with_index do |post, index|
        if index < (@posts.count - 1)
          nextPost = @posts[index + 1]
          expect(nextPost["id"]).to be > post["id"]
        end
      end
    end
  end

  describe "Get posts with tags and sortBy params" do 
    before do
      get api_posts_path, params: {sortBy: "likes", tags: "tech"}
      @posts = JSON.parse(response.body)
    end
    it "posts are ordered by sortBy param - asc by default" do
      expect(response).to have_http_status(200)

      @posts.each_with_index do |post, index|
        if index < (@posts.count - 1)
          nextPost = @posts[index + 1]
          expect(nextPost["likes"]).to be >= post["likes"]
        end
      end
    end
  end

  describe "Get posts with tags and direction params" do 
    before do
      get api_posts_path, params: {direction: "desc", tags: "tech"}
      @posts = JSON.parse(response.body)
    end
    it "posts are ordered by direction param - id by default" do
      expect(response).to have_http_status(200)

      @posts.each_with_index do |post, index|
        if index < (@posts.count - 1)
          nextPost = @posts[index + 1]
          expect(nextPost["id"]).to be < post["id"]
        end
      end
    end
  end

  describe "Get posts with tags, sortBy and direction params" do 
    before do
      get api_posts_path, params: {sortBy: "likes", direction: "desc", tags: "tech"}
      @posts = JSON.parse(response.body)
    end

    it "posts are ordered by sortBy and direction params" do
      expect(response).to have_http_status(200)

      @posts.each_with_index do |post, index|
        if index < (@posts.count - 1)
          nextPost = @posts[index + 1]
          expect(nextPost["likes"]).to be <= post["likes"]
        end
      end
    end
  end
end
