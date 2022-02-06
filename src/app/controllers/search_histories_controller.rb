class SearchHistoriesController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :check_if_login_user, only: [:show]

  def show
  end

  private

  # ログイン中のユーザーか確認
  def check_if_login_user
    user = User.find(params[:id])
    redirect_to root_url unless user == current_user
  end
end
