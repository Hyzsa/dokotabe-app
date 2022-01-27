class SearchResultsController < ApplicationController
  include SearchResultsHelper

  def new
    @shop_info = params[:shop_info]
  end

  def create
    logger.debug "latitude: #{params[:selected][:latitude]} longitude: #{params[:selected][:longitude]}"
    redirect_to new_search_result_path(shop_info: shop_information)
  end
end
