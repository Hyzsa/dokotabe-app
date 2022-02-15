require "rails_helper"

RSpec.describe "Favorites", type: :request do
  let(:user) { create(:user) }

  describe "GET /favorite" do
    context "ログインしている場合" do
      example "お気に入り画面の表示に成功すること" do
        sign_in user
        get favorite_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ログインしていない場合" do
      example "ログイン画面にリダイレクトすること" do
        get favorite_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
