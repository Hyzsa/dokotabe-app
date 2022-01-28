class SearchResultsController < ApplicationController
  include SearchResultsHelper

  def new
    @shop_info = params[:shop_info]
  end

  def create
    redirect_to new_search_result_path(shop_info: shop_information(fetch_at_random_1_shop_information))
  end
end
