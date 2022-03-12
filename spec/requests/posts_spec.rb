require 'rails_helper'

# RSpec.describe "Posts", type: :request do
#   describe "GET /index" do
#     pending "add some examples (or delete) #{__FILE__}"
#   end
# end

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
    # NEED TO FINISH
    it "fails without an invalid sortBy param" do
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["error"]).to eq("Tags parameter is required")
    end
  end

  describe "Get posts with invalid direction param" do 
    before do
      get api_posts_path, params: {direction: "sideways", tags: "tech"}
    end
    # NEED TO FINISH
    it "fails without an invalid direction param" do
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["error"]).to eq("Tags parameter is required")
    end
  end

  describe "Get posts with tags params" do 
    before do
      get api_posts_path, params: {tags: "tech"}
    end
    it "succees with tags param" do
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to be > 0
    end
    it "'tech' tags param only returns posts with selected tag" do
      expect(response).to have_http_status(200)
      JSON.parse(response.body).each do |post|
        expect(post["tags"]).to include("tech")
      end
    end


    # NEEDS TO FINISH
    it "posts are ordered by ascending id if no sortBy and direction parameters are sent" do
      expect(response).to have_http_status(200)
      # JSON.parse(response.body).each do |post|
      #   expect(post["tags"]).to include("tech")
      # end
    end
  end

  describe "Get posts with multiple tags" do 
    before do
      get api_posts_path, params: {tags: "tech,health"}
    end
    it "succees with multips tags param" do
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to be > 0
    end
    it "'tech,health' tags param only returns posts with selected tags" do
      expect(response).to have_http_status(200)
      JSON.parse(response.body).each do |post|
        expect(post["tags"]).to include("tech", "health")
      end
    end
    # NEED TO FINISH
    it "'tech,health' tags param doesn't return duplicate posts" do
      expect(response).to have_http_status(200)
      JSON.parse(response.body).each do |post|
        expect(post["tags"]).to include("tech", "health")
      end
    end


    # NEEDS TO FINISH
    it "posts are ordered by ascending id if no sortBy and direction parameters are sent" do
      expect(response).to have_http_status(200)
      # JSON.parse(response.body).each do |post|
      #   expect(post["tags"]).to include("tech")
      # end
    end
  end

  describe "Get posts with tags and sortBy params" do 
    before do
      get api_posts_path, params: {sortBy: "likes", tags: "tech"}
    end

    # NEEDS TO FINISH
    it "posts are ordered by sortBy param - asc by default" do
      expect(response).to have_http_status(200)
      # JSON.parse(response.body).each do |post|
      #   expect(post["tags"]).to include("tech")
      # end
    end
  end

  describe "Get posts with tags and direction params" do 
    before do
      get api_posts_path, params: {direction: "desc", tags: "tech"}
    end

    # NEEDS TO FINISH
    it "posts are ordered by direction param - id by default" do
      expect(response).to have_http_status(200)
      # JSON.parse(response.body).each do |post|
      #   expect(post["tags"]).to include("tech")
      # end
    end
  end

  describe "Get posts with tags, sortBy and direction params" do 
    before do
      get api_posts_path, params: {sortBy: "likes", direction: "desc", tags: "tech"}
    end

    # NEEDS TO FINISH
    it "posts are ordered by sortBy and direction params" do
      expect(response).to have_http_status(200)
      # JSON.parse(response.body).each do |post|
      #   expect(post["tags"]).to include("tech")
      # end
    end
  end
end
