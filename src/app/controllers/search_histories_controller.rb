class SearchHistoriesController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :check_if_login_user, only: [:show]

  def show
    @histories = current_user.search_histories.page(params[:page]).per(10)
  end
end
