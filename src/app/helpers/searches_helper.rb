module SearchesHelper
  SEARCH_COUNT = 20 # 検索数指定

  # ランダムに１店舗の情報を取得する。
  def fetch_at_random_1_shop_information
    response = gourmet_search_api
    json_hash = JSON.parse(response, symbolize_names: true)
    json_hash[:results][:shop].sample
  end

  # グルメサーチAPI
  def gourmet_search_api
    url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{ENV["HOTPEPPER_API"]}&lat=#{params[:selected][:latitude]}&lng=#{params[:selected][:longitude]}&range=#{params[:selected][:range]}&genre=#{params[:selected][:genre]}&budget=#{params[:selected][:budget]}&count=#{SEARCH_COUNT}&format=json"
    uri = URI.parse(url)
    Net::HTTP.get(uri)
  end

  # 必要な店舗情報を抽出する。
  def extract_required_shop_information(shop_info)
    {
      name: shop_info[:name],
      address: shop_info[:address],
      mobile_access: shop_info[:mobile_access],
      genre: shop_info[:genre][:name],
      budget: shop_info[:budget][:average],
      urls: shop_info[:urls][:pc],
      photo: shop_info[:photo][:pc][:l],
      open: shop_info[:open],
      close: shop_info[:close]
    }
  end

  # 検索結果を保存する。
  def save_search_result(shop_info)
    current_user.search_histories.create(
      shop_id: shop_info[:id],
      shop_name: shop_info[:name],
      shop_photo: shop_info[:photo][:pc][:m],
      shop_url: shop_info[:urls][:pc],
      displayed_date: Time.current
    )
  end
end
