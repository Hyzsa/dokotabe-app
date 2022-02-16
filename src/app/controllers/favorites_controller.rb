class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_login_user, only: [:show]
  before_action :find_same_shop_history, only: [:create, :destroy]

  def show
    @favorites = current_user.favorite_shops.page(params[:page]).per(10)
  end

  def create
    history = SearchHistory.find(params[:history_id])

    # 既に店舗をお気に入りにしてたら追加しない。
    return if current_user.favorite_shop?(history.shop_id)

    favorite = current_user.favorites.build(search_history_id: params[:history_id], shop_id: history.shop_id)
    favorite.save
  end

  def destroy
    history = SearchHistory.find(params[:history_id])

    # 店舗をお気に入りにしてる場合のみ削除する。
    if current_user.favorite_shop?(history.shop_id)
      favorite = Favorite.find_by(user_id: current_user.id, shop_id: history.shop_id)
      favorite.destroy
    end

    # お気に入り画面から呼ばれた場合はリダイレクトする。
    redirect_to favorite_url unless params[:redirect].nil?
  end

  private

  # 同店舗の履歴を見つける
  def find_same_shop_history
    history = SearchHistory.find(params[:history_id])
    @same_shop_histories = SearchHistory.where(user_id: current_user.id, shop_id: history.shop_id)
  end
end
