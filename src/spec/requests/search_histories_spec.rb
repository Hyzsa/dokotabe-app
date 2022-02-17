require "rails_helper"

RSpec.describe "SearchHistories", type: :request do
  let(:user) { create(:user) }

  describe "GET /search_histories/:id" do
    context "ログイン中のユーザーの場合" do
      example "検索履歴画面の表示に成功すること" do
        sign_in user
        get search_history_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ログインしていない場合" do
      example "ログイン画面にリダイレクトすること" do
        get search_history_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
