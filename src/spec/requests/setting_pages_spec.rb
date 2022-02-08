require "rails_helper"

RSpec.describe "SettingPages", type: :request do
  describe "GET /settings" do
    let(:user) { create(:user) }

    context "ログイン中の場合" do
      example "設定画面のHTTPリクエストが成功すること" do
        sign_in user
        get settings_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ログインしていない場合" do
      example "ログイン画面にリダイレクトされること" do
        get settings_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
