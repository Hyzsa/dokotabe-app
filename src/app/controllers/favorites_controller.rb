class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_same_shop_history, only: [:create, :destroy]

  def show
  end

  def create
    history = SearchHistory.find(params[:history_id])
    unless current_user.favorite_shop?(history.shop_id)
      favorite = current_user.favorites.build(search_history_id: params[:history_id], shop_id: history.shop_id)
      favorite.save
    end
  end

  def destroy
    history = SearchHistory.find(params[:history_id])
    if current_user.favorite_shop?(history.shop_id)
      favorite = Favorite.find_by(user_id: current_user.id, shop_id: history.shop_id)
      favorite.destroy
    end
  end

  private

  # 同店舗の履歴を見つける
  def find_same_shop_history
    history = SearchHistory.find(params[:history_id])
    @same_shop_histories = SearchHistory.where(user_id: current_user.id, shop_id: history.shop_id)
  end
end
