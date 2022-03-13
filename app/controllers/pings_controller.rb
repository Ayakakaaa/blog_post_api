class PingsController < ApplicationController

    def index
        # keep rails from returning status 304
        headers['Last-Modified'] = Time.now.httpdate
        
        status = 200
        render json: {success: true}, status: status
    end
end
