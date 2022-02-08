class SearchResultsController < ApplicationController
  include SearchResultsHelper

  def new
    @shop_info = params[:shop_info]
  end

  def create
    shop_info = fetch_at_random_1_shop_information
    if shop_info.nil?
      flash[:danger] = "選択した条件に一致する店舗が見つかりませんでした。"
      redirect_to root_url
    else
      # ユーザーがログインしている場合
      if user_signed_in?
        # 検索結果を保存する。
        save_search_result(shop_info)
      end

      @extracted_shop_info = extract_required_shop_information(shop_info)
      redirect_to new_search_result_url(shop_info: @extracted_shop_info)
    end
  end
end
