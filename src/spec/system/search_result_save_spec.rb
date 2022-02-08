require "rails_helper"

RSpec.describe "Search Result Save", type: :system do
  context "ログインしている時" do
    example "検索時に検索結果を保存すること" do
      user_first = create(:user)
      user_second = create(:user)

      # ログインする
      visit root_path
      click_link "ログイン"
      fill_in "メールアドレス", with: user_first.email
      fill_in "パスワード", with: user_first.password
      click_button "ログイン"

      # 手動で座標設定（必ず店舗が見つかるように、緯度経度に東京駅を指定）
      find("#selected_latitude", visible: false).set "35.6809591"
      find("#selected_longitude", visible: false).set "139.7673068"

      expect { click_button "検索" }.to \
        change { DisplayedShop.all.size }.by(1).and \
          change { user_first.displayed_shops.all.size }.by(1).and \
            change { user_second.displayed_shops.all.size }.by(0)
      expect(page).to have_current_path new_search_result_path, ignore_query: true
    end
  end

  context "ログインしていない時" do
    example "検索時に検索結果を保存しないこと" do
      visit root_path
      # 手動で座標設定（必ず店舗が見つかるように、緯度経度に東京駅を指定）
      find("#selected_latitude", visible: false).set "35.6809591"
      find("#selected_longitude", visible: false).set "139.7673068"

      expect { click_button "検索" }.to change { DisplayedShop.all.size }.by(0)
      expect(page).to have_current_path new_search_result_path, ignore_query: true
    end
  end
end
