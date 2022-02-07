class SearchHistoriesController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :check_if_login_user, only: [:show]

  def show
    @histories = current_user.displayed_shops.page(params[:page]).per(10)
  end

  private

  # ログイン中のユーザーか確認
  def check_if_login_user
    user = User.find(params[:id])
    redirect_to root_url unless user == current_user
  end
end
