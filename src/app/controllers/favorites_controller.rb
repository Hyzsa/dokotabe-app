class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def create
    history = SearchHistory.find(params[:history_id])
    unless current_user.favorite?(history.shop_id)
      favorite = current_user.favorites.build(search_history_id: params[:history_id], shop_id: history.shop_id)
      favorite.save
    end

    redirect_to search_history_url(current_user.id)
  end

  def destroy
    history = SearchHistory.find(params[:id])
    if current_user.favorite?(history.shop_id)
      favorite = Favorite.find_by(user_id: current_user.id, shop_id: history.shop_id)
      favorite.destroy
    end

    redirect_to search_history_url(current_user.id)
  end
end
