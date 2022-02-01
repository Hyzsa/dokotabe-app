require "rails_helper"

RSpec.describe "Devise Pages", type: :system do
  describe "ログイン画面" do
    example "新規登録画面に遷移できること" do
      visit new_user_session_path
      click_link "アカウントの新規登録はこちら"
      expect(page).to have_current_path new_user_registration_path, ignore_query: true
    end
  end

  describe "新規登録画面" do
    example "ログイン画面に遷移できること" do
      visit new_user_registration_path
      click_link "ログインはこちら"
      expect(page).to have_current_path new_user_session_path, ignore_query: true
    end
  end
end
