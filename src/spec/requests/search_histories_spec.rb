require 'rails_helper'

RSpec.describe "SearchHistories", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/search_histories/show"
      expect(response).to have_http_status(:success)
    end
  end

end
