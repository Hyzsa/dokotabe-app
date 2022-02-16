class MemosController < ApplicationController
  def index
    @memo = Memo.new
    @favorite = Favorite.find(params[:favorite_id])

    @shop_info = @favorite.search_history
    @memos = @favorite.memos
  end
end
