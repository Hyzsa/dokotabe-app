require "rails_helper"

RSpec.describe "SettingPages", type: :request do
  describe "GET /settings" do
    context "ログインしている場合" do
      example "設定画面の表示に成功すること" do
        user = create(:user)
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
