class SettingPagesController < ApplicationController
  before_action :authenticate_user!

  def settings
  end

  def unsubscribe
  end
end
