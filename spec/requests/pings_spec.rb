require 'rails_helper'

RSpec.describe PingsController do
  describe "Get status from pings#index" do
    before do
      get api_ping_path
    end
    it "shows status: success and status code" do
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["success"]).to eq(true)
    end
  end
end