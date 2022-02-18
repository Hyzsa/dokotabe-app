class Users::PasswordsController < Devise::PasswordsController
  before_action :ensure_not_guest_user, only: :create

  # ----------------------------
  # before_action
  # ----------------------------
  # パスワード再設定前にゲストユーザーではないことを確認する。
  def ensure_not_guest_user
    if params[:user][:email].downcase == "guest@example.com"
      redirect_to new_user_session_path, alert: "ゲストユーザーのパスワード再設定はできません。"
    end
  end
end
