class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_not_guest_user, only: :destroy

  def destroy
    super
    destroy_internal
  end

  def destroy_internal
  end

  # 既存のupdate関数は、変更失敗時にdeviseが用意している編集画面に飛んでしまうためオーバーライド
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      # 変更失敗時はバリデーションエラーを表示するために設定画面を再描画する。
      session[:error] = resource.errors.full_messages
      redirect_to settings_path
    end
  end

  private

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
