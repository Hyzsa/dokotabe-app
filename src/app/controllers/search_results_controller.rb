class SearchResultsController < ApplicationController
  include SearchResultsHelper

  def new
    @shop_info = params[:shop_info]
  end

  def create
    shop_info = shop_information
    redirect_to new_search_result_path(shop_info: shop_info)
  end
end
