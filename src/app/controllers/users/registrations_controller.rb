class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_not_guest_user, only: :destroy

  def destroy
    super
    destroy_internal
  end

  def destroy_internal
  end

  # ----------------------------
  # before_action
  # ----------------------------
  # アカウント削除前にゲストユーザーではないことを確認する。
  def ensure_not_guest_user
    if resource.email == "guest@example.com"
      redirect_to root_path, alert: "ゲストユーザーは削除できません。"
    end
  end
end
