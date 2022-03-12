class PingsController < ApplicationController

    def index
        status = 200
        render json: {success: true}, status: status
    end
end
