require "rails_helper"

RSpec.describe "Home Pages", type: :system do
  describe "submit" do
    context "ユーザーが位置情報の取得を許可しなかった場合" do
      example "javascript のアラートで「位置情報が取得できませんでした。」が表示されること"
      example "/ にリダイレクトされること"
      example "flashメッセージで「位置情報が取得できませんでした。」が表示されること"
    end

    context "ユーザーが位置情報の取得を許可した場合" do
      example "new_search_result_path(shop_info: shop_information)にリダイレクトされること"
      example "店舗情報が表示されること"
    end
  end
end
