require "rails_helper"

RSpec.describe "Static Pages", type: :request do
  describe "GET /" do
    example "HomeページのHTTPリクエストが成功すること" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /contact" do
    example "ContactページのHTTPリクエストが成功すること" do
      get contact_path
      expect(response).to have_http_status(:success)
    end
  end
end
