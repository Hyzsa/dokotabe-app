require "rails_helper"

RSpec.describe "Home Pages", type: :system, js: true do
  describe "検索機能" do
    context "ユーザーが位置情報の取得を許可しなかった場合" do
      example "アラートメッセージが表示され、ページ遷移しないこと" do
        visit root_path
        accept_alert("位置情報が取得できませんでした。\nお手持ちの端末にて、位置情報の利用を許可してください。") do
          click_button("search")
        end
        expect(page).to have_current_path root_path, ignore_query: true
      end
    end

    context "ユーザーが位置情報の取得を許可した場合" do
      example "アラートメッセージが表示されずに、検索結果が表示されること"
      # selenium-dockerのChromeで位置情報を設定する方法が不明のためSKIP
      # requests specで以下のテストを実施しているため対応優先度：低
      # └ example "検索結果表示画面にリダイレクトすること"
    end
  end
end
