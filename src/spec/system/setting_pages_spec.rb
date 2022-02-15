require "rails_helper"

RSpec.describe "Setting Pages", type: :system, js: true do
  describe "レイアウト確認" do
    before do
      user = create(:user)
      log_in_as(user)
    end

    example "設定画面の要素が正しく表示されること" do
      visit settings_path
      expect(page).to have_current_path settings_path

      expect(page).to have_selector "h1", text: "設定画面"
      expect(page).to have_link "退会", href: unsubscribe_path
    end

    example "退会画面の要素が正しく表示されること" do
      visit settings_path
      click_link "退会", href: unsubscribe_path
      expect(page).to have_current_path settings_path

      expect(page).to have_selector "h2", text: "退会手続き"
      expect(page).to have_selector "p", text: "退会手続きが完了した時点で"
      expect(page).to have_link "退会をやめる", href: root_path
      expect(page).to have_button "退会する"
    end
  end

  describe "退会" do
    example "退会が正常にできること" do
      user = create(:user)
      create_list(:search_history, 10, user_id: user.id)

      # ログインする
      log_in_as(user)

      click_link "アカウント"
      click_link "設定"
      expect(page).to have_current_path settings_path
      expect(page).to have_link "退会", href: unsubscribe_path

      # [退会]ボタンを選択する
      click_link "退会", href: unsubscribe_path
      expect(page).to have_content "退会手続き"

      # [退会をやめる]ボタンを選択する
      click_link "退会をやめる"
      expect(page).to have_current_path root_path

      click_link "アカウント"
      click_link "設定"
      expect(page).to have_current_path settings_path
      expect(page).to have_link "退会", href: unsubscribe_path

      # 退会確認で[キャンセル]を選択する
      expect do
        dismiss_confirm("本当に退会しますか？") { click_button "退会する" }
        expect(page).to have_current_path settings_path
        expect(page).to have_content "退会手続き"
      end.to \
        change { User.count }.by(0).and \
          change { user.search_histories.count }.by(0)

      # 退会確認で[OK]を選択する
      expect do
        accept_confirm("本当に退会しますか？") { click_button "退会する" }
        expect(page).to have_current_path root_path
        expect(page).to have_content "アカウントを削除しました。またのご利用をお待ちしております。"
      end.to \
        change { User.count }.by(-1).and \
          change { user.search_histories.count }.by(-10)
    end
  end
end
