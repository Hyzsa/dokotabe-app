require "rails_helper"

RSpec.describe "Links", type: :system do
  shared_examples "ログイン画面に遷移できること" do
    example do
      click_link "ログインはこちら"
      expect(page).to have_current_path new_user_session_path, ignore_query: true
    end
  end

  shared_examples "新規登録画面に遷移できること" do
    example do
      click_link "アカウントの新規登録はこちら"
      expect(page).to have_current_path new_user_registration_path, ignore_query: true
    end
  end

  shared_examples "認証メール再送画面に遷移できること" do
    example do
      click_link "認証メールが届かなかった場合はこちら"
      expect(page).to have_current_path new_user_confirmation_path, ignore_query: true
    end
  end

  shared_examples "パスワード再設定画面（メール送信用）に遷移できること" do
    example do
      click_link "パスワードを忘れた方はこちら"
      expect(page).to have_current_path new_user_password_path, ignore_query: true
    end
  end

  describe "ログイン画面" do
    before do
      visit root_path
      click_link "ログイン"
    end

    it_behaves_like "新規登録画面に遷移できること"
    it_behaves_like "パスワード再設定画面（メール送信用）に遷移できること"
    it_behaves_like "認証メール再送画面に遷移できること"
  end

  describe "新規登録画面" do
    before do
      visit root_path
      click_link "ログイン"
      click_link "アカウントの新規登録はこちら"
    end

    it_behaves_like "ログイン画面に遷移できること"
    it_behaves_like "認証メール再送画面に遷移できること"
  end

  describe "認証メール再送画面" do
    before do
      visit root_path
      click_link "ログイン"
      click_link "認証メールが届かなかった場合はこちら"
    end

    it_behaves_like "ログイン画面に遷移できること"
    it_behaves_like "新規登録画面に遷移できること"
    it_behaves_like "パスワード再設定画面（メール送信用）に遷移できること"
  end

  describe "パスワード再設定画面（メール送信用）" do
    before do
      visit root_path
      click_link "ログイン"
      click_link "パスワードを忘れた方はこちら"
    end

    it_behaves_like "ログイン画面に遷移できること"
    it_behaves_like "新規登録画面に遷移できること"
    it_behaves_like "認証メール再送画面に遷移できること"
  end

  describe "パスワード再設定画面" do
    before do
      # 適当なトークンをクエリで渡してパスワード変更画面にアクセスする
      visit edit_user_password_url(reset_password_token: Devise.friendly_token(10))
    end

    it_behaves_like "ログイン画面に遷移できること"
    it_behaves_like "新規登録画面に遷移できること"
    it_behaves_like "認証メール再送画面に遷移できること"
  end
end
