module SearchResultsHelper
  # 店舗情報を返す
  def shop_information
    {
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
  end
end
