require "rails_helper"

RSpec.describe "Search Result Save", type: :system do
  describe "レイアウト確認" do
    example "検索結果画面の要素が正しく表示されること" do
      visit root_path
      # 手動で座標設定（必ず店舗が見つかるように、緯度経度に東京駅を指定）
      find("#selected_latitude", visible: false).set "35.6809591"
      find("#selected_longitude", visible: false).set "139.7673068"
      click_button "検索"

      expect(page).to have_selector ".shop-info > h1"
      expect(page).to have_selector ".shop-info > p", text: "平均予算："
      expect(page).to have_selector ".shop-info > .result-photo"
      expect(page).to have_selector ".result-photo > a > img[alt=店舗トップ写真]"
      expect(page).to have_selector ".result-photo > a > p"
      expect(page).to have_selector ".shop-info h2", text: "住所・アクセス"
      expect(page).to have_selector ".shop-info h2 + p"
      expect(page).to have_selector ".shop-info h2 + p", text: "定休日："
    end
  end

  describe "検索結果保存機能" do
    context "ログインしている時" do
      example "検索時に検索結果を保存すること" do
        user_first = create(:user)
        user_second = create(:user)

        # ログインする
        log_in_as(user_first)

        # 手動で座標設定（必ず店舗が見つかるように、緯度経度に東京駅を指定）
        find("#selected_latitude", visible: false).set "35.6809591"
        find("#selected_longitude", visible: false).set "139.7673068"

        expect { click_button "検索" }.to \
          change { SearchHistory.count }.by(1).and \
            change { user_first.search_histories.count }.by(1).and \
              change { user_second.search_histories.count }.by(0)
        expect(page).to have_current_path search_result_path, ignore_query: true
      end
    end

    context "ログインしていない時" do
      example "検索時に検索結果を保存しないこと" do
        visit root_path
        # 手動で座標設定（必ず店舗が見つかるように、緯度経度に東京駅を指定）
        find("#selected_latitude", visible: false).set "35.6809591"
        find("#selected_longitude", visible: false).set "139.7673068"

        expect { click_button "検索" }.to change { SearchHistory.count }.by(0)
        expect(page).to have_current_path search_result_path, ignore_query: true
      end
    end
  end
end
