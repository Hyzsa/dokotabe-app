require "rails_helper"

RSpec.describe "Sessions", type: :system do
  describe "レイアウト確認" do
    example "ログイン画面の要素が正しく表示されること" do
      visit new_user_session_path
      expect(page).to have_current_path new_user_session_path

      expect(page).to have_selector "h1", text: "ログイン"
      expect(page).to have_selector "label[for=user_email]", text: "メールアドレス"
      expect(page).to have_selector "input#user_email"
      expect(page).to have_selector "label[for=user_password]", text: "パスワード"
      expect(page).to have_selector "input#user_password"
      expect(page).to have_button "ログイン"
      expect(page).to have_link "ゲストログイン", href: users_guest_sign_in_path
    end
  end

  describe "認証機能確認" do
    let(:valid_user) { create(:user) }
    let(:invalid_user) { create(:user, confirmed_at: nil) }

    describe "ログイン" do
      before do
        visit root_path
        click_link "ログイン"
      end

      context "本人確認実施済みのログイン情報でログインした場合" do
        example "ログインできること" do
          expect(page).to have_current_path new_user_session_path
          fill_in_login_form(valid_user)
          click_button "ログイン"

          expect(page).to have_current_path root_path
          expect(page).to have_content "ログインしました。"
        end
      end

      context "本人確認未実施のログイン情報でログインした場合" do
        example "ログインできないこと" do
          expect(page).to have_current_path new_user_session_path
          fill_in_login_form(invalid_user)
          click_button "ログイン"

          expect(page).to have_current_path new_user_session_path
          expect(page).to have_content "メールアドレスの本人確認が必要です。"
        end
      end

      context "誤ったログイン情報でログインした場合" do
        example "ログインできないこと" do
          expect(page).to have_current_path new_user_session_path
          fill_in_login_form(build(:user, email: "", password: ""))
          click_button "ログイン"

          expect(page).to have_current_path new_user_session_path
          expect(page).to have_content "メールアドレスまたはパスワードが違います。"
        end
      end
    end

    describe "ログアウト" do
      context "ログインしている場合" do
        example "ログアウトできること" do
          log_in_as(valid_user)

          expect(page).to have_current_path root_path
          expect(page).to have_selector(".dropdown-toggle", text: "アカウント")
          expect(page).to have_link "ログアウト"
          click_link "ログアウト"

          expect(page).to have_current_path root_path
          expect(page).to have_content "ログアウトしました。"
        end
      end

      context "ログインしていない場合" do
        example "ログアウトできないこと" do
          visit root_path

          expect(page).to have_no_selector(".dropdown-toggle", text: "アカウント")
          expect(page).to have_no_link "ログアウト"
        end
      end
    end

    describe "ゲストログイン" do
      before do
        visit root_path
        click_link "ログイン"
        click_link "ゲストログイン", href: users_guest_sign_in_path
      end

      example "ゲストユーザーでログインできること" do
        expect(page).to have_current_path root_path
        expect(page).to have_content "ゲストユーザーとしてログインしました。"
      end

      example "ゲストユーザーがログアウトできること" do
        expect(page).to have_current_path root_path
        expect(page).to have_content "ゲストユーザーとしてログインしました。"

        click_link "ログアウト"
        expect(page).to have_current_path root_path
        expect(page).to have_content "ログアウトしました。"
      end
    end
  end
end
