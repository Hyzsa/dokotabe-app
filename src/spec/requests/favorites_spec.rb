require "rails_helper"

RSpec.describe "Favorites", type: :request do
  let(:user_first) { create(:user) }
  let(:user_second) { create(:user) }

  describe "GET /favorite" do
    context "ログインしている場合" do
      example "お気に入り画面の表示に成功すること" do
        sign_in user_first
        get favorite_path(user_first)
        expect(response).to have_http_status(:success)
      end
    end

    context "ログイン中のユーザー以外の場合" do
      example "ホーム画面にリダイレクトすること" do
        sign_in user_first
        get favorite_path(user_second)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログインしていない場合" do
      example "ログイン画面にリダイレクトすること" do
        get favorite_path(user_first)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
