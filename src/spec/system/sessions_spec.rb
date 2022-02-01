require "rails_helper"

RSpec.describe "Sessions", type: :system do
  before do
    @user = FactoryBot.create(:user)
    visit new_user_session_path
  end

  describe "ログイン" do
    context "誤った情報でログインした場合" do
      before do
        fill_in "メールアドレス", with: ""
        fill_in "パスワード", with: ""
        click_button "ログイン"
      end

      example "ログイン画面から遷移しないこと" do
        expect(page).to have_current_path new_user_session_path, ignore_query: true
      end

      example "ログイン失敗時のflashメッセージが表示されること" do
        expect(page).to have_selector(".alert-warning", text: "メールアドレスまたはパスワードが違います。")
      end

      example "リロードでflashメッセージが消えること" do
        visit new_user_session_path
        expect(page).to_not have_selector(".alert-warning", text: "メールアドレスまたはパスワードが違います。")
      end
    end

    context "正しい情報でログインした場合" do
      before do
        fill_in "メールアドレス", with: @user.email
        fill_in "パスワード", with: "password"
        click_button "ログイン"
      end

      example "ホーム画面に遷移すること" do
        expect(page).to have_current_path root_path, ignore_query: true
      end

      example "ログイン成功時のflashメッセージが表示されること" do
        expect(page).to have_selector(".alert-success", text: "ログインしました。")
      end

      example "リロードでflashメッセージが消えること" do
        visit root_path
        expect(page).to_not have_selector(".alert-success", text: "ログインしました。")
      end
    end
  end

  describe "ログアウト" do
    before do
      fill_in "メールアドレス", with: @user.email
      fill_in "パスワード", with: "password"
      click_button "ログイン"
      click_link "ログアウト"
    end

    example "ホーム画面に遷移すること" do
      expect(page).to have_current_path root_path, ignore_query: true
    end

    example "ログアウト時のflashメッセージが表示されること" do
      expect(page).to have_selector(".alert-success", text: "ログアウトしました。")
    end

    example "リロードでflashメッセージが消えること" do
      visit root_path
      expect(page).to_not have_selector(".alert-success", text: "ログアウトしました。")
    end
  end
end
