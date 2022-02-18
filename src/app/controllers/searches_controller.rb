class SearchesController < ApplicationController
  include SearchesHelper

  def search
    shop_info = fetch_at_random_1_shop_information
    if shop_info.nil?
      flash[:danger] = "選択した条件に一致する店舗が見つかりませんでした。"
      redirect_to root_url
    else
      # ユーザーがログインしていれば検索結果を保存する。
      current_user.save_search_result(shop_info) if user_signed_in?

      @extracted_shop_info = extract_required_shop_information(shop_info)
      redirect_to search_result_url(shop_info: @extracted_shop_info)
    end
  end

  def result
    @shop_info = params[:shop_info]
  end
end
