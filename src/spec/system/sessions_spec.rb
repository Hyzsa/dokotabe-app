require "rails_helper"

RSpec.describe "Sessions", type: :system do
  let(:valid_user) { create(:user) }
  let(:invalid_user) { create(:user, confirmed_at: nil) }

  before do
    visit new_user_session_path
  end

  describe "ログイン" do
    context "誤ったログイン情報でログインした場合" do
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

    context "本人確認未実施のログイン情報でログインした場合" do
      before do
        fill_in "メールアドレス", with: invalid_user.email
        fill_in "パスワード", with: invalid_user.password
        click_button "ログイン"
      end

      example "ログイン画面から遷移しないこと" do
        expect(page).to have_current_path new_user_session_path, ignore_query: true
      end
      example "本人確認未実施のflashメッセージが表示されること" do
        expect(page).to have_selector(".alert-warning", text: "メールアドレスの本人確認が必要です。")
      end
      example "リロードでflashメッセージが消えること" do
        visit root_path
        expect(page).to_not have_selector(".alert-warning", text: "メールアドレスの本人確認が必要です。")
      end
    end

    context "本人確認実施済みのログイン情報でログインした場合" do
      before do
        fill_in "メールアドレス", with: valid_user.email
        fill_in "パスワード", with: valid_user.password
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
      fill_in "メールアドレス", with: valid_user.email
      fill_in "パスワード", with: valid_user.password
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
