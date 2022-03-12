require 'net/http'
class PostsController < ApplicationController
    def index
        render json: {"success": "success"}, status: 200
    end
end
