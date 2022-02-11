require "rails_helper"

RSpec.describe "devise", type: :request do
  describe "GET /users/sign_in" do
    example "ログイン画面の表示に成功すること" do
      get new_user_session_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /users/sign_up" do
    example "新規登録画面の表示に成功すること" do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /users/confirmation/new" do
    example "認証メール再送画面の表示に成功すること" do
      get new_user_confirmation_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /users/password/new" do
    example "パスワード再設定（メール送信）画面の表示に成功すること" do
      get new_user_password_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /users/password/edit" do
    example "パスワード再設定画面の表示に成功すること" do
      get edit_user_password_url(reset_password_token: Devise.friendly_token(10))
      expect(response).to have_http_status(:success)
    end
  end
end
