require "rails_helper"

RSpec.describe "Search Results", type: :request do
  describe "POST /search_results" do
    context "店舗が見つからなかった場合" do
      example "ホーム画面にリダイレクトすること" do
        # 必ず店舗が見つからないように、緯度経度にヌル島(0度)を指定
        post search_results_path, params: { selected: { range: "3",
                                                        genre: "",
                                                        budget: "",
                                                        latitude: "0",
                                                        longitude: "0" } }
        expect(response).to redirect_to(root_url)
      end
    end

    context "店舗が見つかった場合" do
      example "検索結果表示画面にリダイレクトすること" do
        # 必ず店舗が見つかるように、緯度経度に東京駅を指定
        post search_results_path, params: { selected: { range: "3",
                                                        genre: "",
                                                        budget: "",
                                                        latitude: "35.6809591",
                                                        longitude: "139.7673068" } }
        extracted_shop_info = controller.instance_variable_get(:@extracted_shop_info)
        expect(response).to redirect_to(new_search_result_path(shop_info: extracted_shop_info))
      end
    end
  end
end
