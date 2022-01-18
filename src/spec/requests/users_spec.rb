require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    it "リクエストが成功すること" do
      get users_path
      # get '/'
      expect(response).to have_http_status(200)
    end
  end
end
