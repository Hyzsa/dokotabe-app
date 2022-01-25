require "rails_helper"

RSpec.describe "Search Results", type: :request do
  # describe "GET /search_results/new" do
  #   example "検索結果画面のHTTPリクエストが成功すること" do
  #     get new_search_result_path
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  describe "POST /search_results" do
    example "[検索]ボタン押下時のHTTPリクエストが成功すること" do
      @shop_info = {
        name: "ここに店名が表示されます。",
        address: "ここに店舗の住所が表示されます。",
        mobile_access: "ここに店舗へのアクセス方法が表示されます。",
        genre: "ジャンル", # genre - name
        budget: "XXXX円～XXXX円", # budget - average
        urls: "#",
        photo: "", # photo - pc - l
        open: "ここに営業時間が表示されます。",
        close: "ここに定休日が表示されます。"
      }

      post search_results_path, params: { selected: { range: "", genre: "", budget: "" } }
      expect(response).to redirect_to(new_search_result_path(shop_info: @shop_info))
    end
  end
end
