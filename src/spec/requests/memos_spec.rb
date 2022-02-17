require 'rails_helper'

RSpec.describe "Memos", type: :request do
  let(:user_first) { create(:user) }
  let(:user_second) { create(:user) }

  describe "GET /favorites/:favorite_id/memos" do
    context "ログインしている場合" do
      context "ログインユーザーのお気に入り店舗の場合" do
        example "メモ一覧画面の表示に成功すること" do
          # ユーザー1に紐づけたお気に入りを作成
          favorite = create(:favorite, user_id: user_first.id)

          sign_in user_first
          get favorite_memos_path(favorite)
          expect(response).to have_http_status(:success)
        end
      end

      context "ログインユーザーのお気に入り店舗ではない場合" do
        example "ログイン中ユーザーのお気に入り画面にリダイレクトすること" do
          # ユーザー2に紐づけたお気に入りを作成
          favorite = create(:favorite, user_id: user_second.id)

          sign_in user_first
          get favorite_memos_path(favorite)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(favorite_url(user_first))
        end
      end
    end

    context "ログインしていない場合" do
      example "ログイン画面にリダイレクトすること" do
        # ユーザー1に紐づけたお気に入りを作成
        favorite = create(:favorite, user_id: user_first.id)

        get favorite_memos_path(favorite)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
