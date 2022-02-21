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
      expect(page).to have_link "ユーザー情報編集", href: user_info_edit_path
      expect(page).to have_link "退会", href: unsubscribe_path
    end

    example "ユーザー情報編集画面の要素が正しく表示されること" do
      visit settings_path
      click_link "ユーザー情報編集", href: user_info_edit_path
      expect(page).to have_current_path settings_path

      expect(page).to have_selector "h2", text: "ユーザー情報編集"
      expect(page).to have_selector "label[for=user_email]", text: "メールアドレス"
      expect(page).to have_selector "input#user_email"
      expect(page).to have_selector "label[for=user_password]", text: "新しいパスワード"
      expect(page).to have_selector "input#user_password"
      expect(page).to have_selector "label[for=user_password_confirmation]", text: "新しいパスワード（確認用）"
      expect(page).to have_selector "input#user_password_confirmation"
      expect(page).to have_selector "label[for=user_current_password]", text: "現在のパスワード ※必須"
      expect(page).to have_selector "input#user_current_password"
      expect(page).to have_button "変更する"
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
end
