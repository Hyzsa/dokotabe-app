class ApplicationController < ActionController::Base
  # ログイン中のユーザーか確認する。
  def check_if_login_user
    user = User.find(params[:id])
    redirect_to root_url unless user == current_user
  end
end
