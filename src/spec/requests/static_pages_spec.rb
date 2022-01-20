require "rails_helper"

RSpec.describe "StaticPages", type: :request do
  describe "GET /home" do
    it "リクエストが成功すること" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /contact" do
    it "リクエストが成功すること" do
      get contact_path
      expect(response).to have_http_status(:success)
    end
  end
end
