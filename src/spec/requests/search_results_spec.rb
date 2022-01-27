require "rails_helper"

RSpec.describe "Search Results", type: :request do
  describe "POST /search_results" do
    shop_info = {
      name: "ここに店名が表示されます。",
      address: "ここに店舗の住所が表示されます。",
      mobile_access: "ここに店舗へのアクセス方法が表示されます。",
      genre: "ジャンル",
      budget: "XXXX円～XXXX円",
      urls: "#",
      photo: "",
      open: "ここに営業時間が表示されます。",
      close: "ここに定休日が表示されます。"
    }

    context "位置情報が取得できた場合" do
      example "/search_results/new へのリダイレクトが成功すること" do
        post search_results_path,
             params: { selected: { range: "", genre: "", budget: "", latitude: "1", longitude: "1" } }
        expect(response).to redirect_to(new_search_result_path(shop_info: shop_info))
      end
    end

    context "位置情報が取得できなかった場合" do
      example "/ にリダイレクトすること" do
        post search_results_path,
             params: { selected: { range: "", genre: "", budget: "", latitude: "", longitude: "" } }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
