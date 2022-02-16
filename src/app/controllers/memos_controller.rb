class MemosController < ApplicationController
  before_action :current_user_favorite_shop

  def index
    @memo = Memo.new
    @favorite = Favorite.find(params[:favorite_id])
    @shop_info = @favorite.search_history

    # 最新のメモが先頭になるように並び替える。
    @memos = @favorite.memos.order(id: "DESC").page(params[:page]).per(10)
  end

  def create
    favorite = Favorite.find(params[:favorite_id])
    memo = favorite.memos.new(memo_params)
    if memo.save
      redirect_to favorite_memos_url
    else
      # エラーメッセージをflashで表示する。
      redirect_to favorite_memos_url, flash: { error: memo.errors.full_messages[0] }
    end
  end

  private

  # ログイン中のユーザーのお気に入り店舗かを確認する。
  def current_user_favorite_shop
    favorite = Favorite.find(params[:favorite_id])
    redirect_to favorite_url(current_user) unless current_user.id == favorite.user_id
  end

  def memo_params
    params.require(:memo).permit(:content)
  end
end
