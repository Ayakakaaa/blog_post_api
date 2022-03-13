require 'rails_helper'

RSpec.describe PostsController do
  describe "Get posts without any params -" do
    before do
      get api_posts_path
    end
    it "fails with status 400 and error code" do
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["error"]).to eq("Tags parameter is required")
    end
  end

  describe "Get posts with invalid sortBy param -" do 
    before do
      get api_posts_path, params: {sortBy: "rating", tags: "tech"}
    end
    it "fails with status 400 and error code" do
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["error"]).to eq("sortedBy parameter is invalid")
    end
  end

  describe "Get posts with invalid direction param -" do 
    before do
      get api_posts_path, params: {direction: "sideways", tags: "tech"}
    end
    it "fails with status 400 and error code" do
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["error"]).to eq("direction parameter is invalid")
    end
  end

  describe "Get posts with only 'tech' tags param -" do 
    before do
      get api_posts_path, params: {tags: "tech"}
      @posts = JSON.parse(response.body)
    end
    it "returns success code and posts" do
      expect(response).to have_http_status(200)
      expect(@posts.count).to be > 0
    end
    it "returns success code and only 'tech' posts" do
      expect(response).to have_http_status(200)
      @posts.each do |post|
        expect(post["tags"]).to include("tech")
      end
    end
    it "posts have required fields" do
      expect(response).to have_http_status(200)

      @posts.each do |post|
        expect([
          post["id"],
          post["author"],
          post["authorId"],
          post["likes"],
          post["popularity"],
          post["reads"],
          post["tags"],
        ].all?(&:present?)).to eq(true)
      end
    end
    it "posts are ordered by ascending id" do
      expect(response).to have_http_status(200)

      @posts.each_with_index do |post, index|
        if index < (@posts.count - 1)
          nextPost = @posts[index + 1]
          expect(nextPost["id"]).to be > post["id"]
        end
      end
    end
  end

  describe "Get posts with only multiple ('tech', 'health') tags -" do 
    before do
      get api_posts_path, params: {tags: "tech,health"}
      @posts = JSON.parse(response.body)
    end
    it "returns success code and posts" do
      expect(response).to have_http_status(200)
      expect(@posts.count).to be > 0
    end
    it "returns success code and only 'tech' and 'health' posts" do
      expect(response).to have_http_status(200)
      @posts.each do |post|
        expect(post["tags"].include?("tech") || post["tags"].include?("health")).to be true
      end
    end
    it "no duplicate posts" do
      expect(response).to have_http_status(200)
      expect(@posts.count).to eq(@posts.uniq { |p| p["id"]}.count)
    end
    it "posts are ordered by ascending id" do
      expect(response).to have_http_status(200)

      @posts.each_with_index do |post, index|
        if index < (@posts.count - 1)
          nextPost = @posts[index + 1]
          expect(nextPost["id"]).to be > post["id"]
        end
      end
    end
  end

  describe "Get posts with only tags and 'likes' sortBy params -" do 
    before do
      get api_posts_path, params: {sortBy: "likes", tags: "tech"}
      @posts = JSON.parse(response.body)
    end
    it "posts are ordered by ascending likes" do
      expect(response).to have_http_status(200)

      @posts.each_with_index do |post, index|
        if index < (@posts.count - 1)
          nextPost = @posts[index + 1]
          expect(nextPost["likes"]).to be >= post["likes"]
        end
      end
    end
  end

  describe "Get posts with only tags and 'reads' sortBy params -" do 
    before do
      get api_posts_path, params: {sortBy: "reads", tags: "tech"}
      @posts = JSON.parse(response.body)
    end
    it "posts are ordered by ascending reads" do
      expect(response).to have_http_status(200)

      @posts.each_with_index do |post, index|
        if index < (@posts.count - 1)
          nextPost = @posts[index + 1]
          expect(nextPost["reads"]).to be >= post["reads"]
        end
      end
    end
  end

  describe "Get posts with tags and 'popularity' sortBy params -" do 
    before do
      get api_posts_path, params: {sortBy: "popularity", tags: "tech"}
      @posts = JSON.parse(response.body)
    end
    it "posts are ordered by ascending popularity" do
      expect(response).to have_http_status(200)

      @posts.each_with_index do |post, index|
        if index < (@posts.count - 1)
          nextPost = @posts[index + 1]
          expect(nextPost["popularity"]).to be >= post["popularity"]
        end
      end
    end
  end

  describe "Get posts with only tags and 'desc' direction params -" do 
    before do
      get api_posts_path, params: {direction: "desc", tags: "tech"}
      @posts = JSON.parse(response.body)
    end
    it "posts are ordered by descending id" do
      expect(response).to have_http_status(200)

      @posts.each_with_index do |post, index|
        if index < (@posts.count - 1)
          nextPost = @posts[index + 1]
          expect(nextPost["id"]).to be < post["id"]
        end
      end
    end
  end

  describe "Get posts with tags, 'likes' sortBy and 'desc' direction params -" do 
    before do
      get api_posts_path, params: {sortBy: "likes", direction: "desc", tags: "tech"}
      @posts = JSON.parse(response.body)
    end

    it "posts are ordered by descending likes" do
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
