class MemosController < ApplicationController
  def index
    @memo = Memo.new
    @favorite = Favorite.find(params[:favorite_id])

    @shop_info = @favorite.search_history
    @memos = @favorite.memos
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

  def memo_params
    params.require(:memo).permit(:content)
  end
end
