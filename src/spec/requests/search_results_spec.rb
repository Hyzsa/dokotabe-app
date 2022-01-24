require "rails_helper"

RSpec.describe "Search Results", type: :request do
  describe "GET /search_results/new" do
    example "検索結果画面のHTTPリクエストが成功すること" do
      get new_search_result_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /search_results" do
    # 後でAPIのテストに置き換える
    example "検索のHTTPリクエストが成功すること" do
      post search_results_path, params: { selected: { range: "", genre: "", budget: "" } }
      expect(response).to have_http_status(:success)
    end
  end
end
