class SearchResultsController < ApplicationController
  include SearchResultsHelper

  def new
    @shop_info = params[:shop_info]
  end

  def create
    if params[:selected][:latitude].empty? || params[:selected][:longitude].empty?
      flash[:danger] = "位置情報が取得できませんでした。"
      redirect_to root_path
    else
      logger.debug "latitude: #{params[:selected][:latitude]} longitude: #{params[:selected][:longitude]}"
      redirect_to new_search_result_path(shop_info: shop_information)
    end
  end
end
