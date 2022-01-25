class SearchResultsController < ApplicationController
  def new
    @shop_info = params[:shop_info]
  end

  def create
    @shop_info = {
      name: "ここに店名が表示されます。",
      address: "ここに店舗の住所が表示されます。",
      mobile_access: "ここに店舗へのアクセス方法が表示されます。",
      genre: "ジャンル", # genre - name
      budget: "XXXX円～XXXX円", # budget - average
      urls: "#",
      photo: "", # photo - pc - l
      open: "ここに営業時間が表示されます。",
      close: "ここに定休日が表示されます。"
    }

    redirect_to new_search_result_path(shop_info: @shop_info)
    # render "new" # params確認用
  end
end
