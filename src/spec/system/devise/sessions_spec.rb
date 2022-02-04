require "rails_helper"

RSpec.describe "Sessions", type: :system do
  let(:valid_user) { create(:user) }
  let(:invalid_user) { create(:user, confirmed_at: nil) }

  def fill_in_login_form(user)
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
  end

  describe "ログイン" do
    before do
      visit root_path
      click_link "ログイン"
      expect(page).to have_current_path new_user_session_path, ignore_query: true
    end

    context "本人確認実施済みのログイン情報でログインした場合" do
      example "ログインできること" do
        fill_in_login_form(valid_user)
        click_button "ログイン"
        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).to have_content "ログインしました。"
      end
    end

    context "本人確認未実施のログイン情報でログインした場合" do
      example "ログインできないこと" do
        fill_in_login_form(invalid_user)
        click_button "ログイン"
        expect(page).to have_current_path new_user_session_path, ignore_query: true
        expect(page).to have_content "メールアドレスの本人確認が必要です。"
      end
    end

    context "誤ったログイン情報でログインした場合" do
      example "ログインできないこと" do
        fill_in_login_form(build(:user, email: "", password: ""))
        click_button "ログイン"
        expect(page).to have_current_path new_user_session_path, ignore_query: true
        expect(page).to have_content "メールアドレスまたはパスワードが違います。"
      end
    end
  end

  describe "ログアウト" do
    context "ログインしている場合" do
      example "ログアウトできること" do
        visit root_path
        click_link "ログイン"
        expect(page).to have_current_path new_user_session_path, ignore_query: true
        fill_in_login_form(valid_user)
        click_button "ログイン"

        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).to have_selector(".dropdown-toggle", text: "アカウント")
        expect(page).to have_link "ログアウト"
        click_link "ログアウト"
        expect(page).to have_content "ログアウトしました。"
      end
    end

    context "ログインしていない場合" do
      example "ログアウトできないこと" do
        visit root_path
        expect(page).to_not have_selector(".dropdown-toggle", text: "アカウント")
        expect(page).to_not have_link "ログアウト"
      end
    end
  end
end
