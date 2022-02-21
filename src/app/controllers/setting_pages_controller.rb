class SettingPagesController < ApplicationController
  before_action :authenticate_user!

  def settings
    @user = current_user
  end

  def unsubscribe
  end

  def user_info_edit
    @user = current_user
  end
end
