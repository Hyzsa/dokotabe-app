require "rails_helper"

RSpec.describe "Home Pages", type: :system do
  before do
    visit root_path
  end

  describe "検索機能" do
    context "ユーザーが位置情報の取得を許可しなかった場合", js: true do
      example "アラートメッセージが表示されること" do
        accept_alert("位置情報が取得できませんでした。\nお手持ちの端末にて、位置情報の利用を許可してください。") do
          click_button "検索"
        end

        expect(page).to have_current_path root_path, ignore_query: true
      end
    end

    context "ユーザーが位置情報の取得を許可した場合" do
      context "条件に一致する店舗が見つかった場合" do
        example "検索結果画面が表示されること" do
          # 手動で座標設定（必ず店舗が見つかるように、緯度経度に東京駅を指定）
          find("#selected_latitude", visible: false).set "35.6809591"
          find("#selected_longitude", visible: false).set "139.7673068"
          click_button "検索"

          expect(page).to have_current_path new_search_result_path, ignore_query: true
        end
      end

      context "条件に一致する店舗が見つからなかった場合" do
        example "店舗が見つからなかった旨のフラッシュメッセージが表示されること" do
          # 手動で座標設定（必ず店舗が見つからないように、緯度経度にヌル島(0度)を指定）
          find("#selected_latitude", visible: false).set "0"
          find("#selected_longitude", visible: false).set "0"
          click_button "検索"

          expect(page).to have_current_path root_path, ignore_query: true
          expect(page).to have_content "選択した条件に一致する店舗が見つかりませんでした。"
        end
      end
    end
  end

  describe "レイアウト確認" do
    example "検索範囲の選択肢が正しく設定されていること" do
      expect(page).to have_selector "option[value='1']", text: "検索範囲：300m"
      expect(page).to have_selector "option[value='2']", text: "検索範囲：500m"
      expect(page).to have_selector "option[value='3']", text: "検索範囲：1000m"
      expect(page).to have_selector "option[value='4']", text: "検索範囲：2000m"
      expect(page).to have_selector "option[value='5']", text: "検索範囲：3000m"
    end

    example "ジャンルの選択肢が正しく設定されていること" do
      expect(page).to have_selector "option[value='']", text: "お店のジャンル：すべて"
      expect(page).to have_selector "option[value='G001']", text: "居酒屋"
      expect(page).to have_selector "option[value='G002']", text: "ダイニングバー・バル"
      expect(page).to have_selector "option[value='G003']", text: "創作料理"
      expect(page).to have_selector "option[value='G004']", text: "和食"
      expect(page).to have_selector "option[value='G005']", text: "洋食"
      expect(page).to have_selector "option[value='G006']", text: "イタリアン・フレンチ"
      expect(page).to have_selector "option[value='G007']", text: "中華"
      expect(page).to have_selector "option[value='G008']", text: "焼肉・ホルモン"
      expect(page).to have_selector "option[value='G017']", text: "韓国料理"
      expect(page).to have_selector "option[value='G009']", text: "アジア・エスニック料理"
      expect(page).to have_selector "option[value='G010']", text: "各国料理"
      expect(page).to have_selector "option[value='G011']", text: "カラオケ・パーティ"
      expect(page).to have_selector "option[value='G012']", text: "バー・カクテル"
      expect(page).to have_selector "option[value='G013']", text: "ラーメン"
      expect(page).to have_selector "option[value='G016']", text: "お好み焼き・もんじゃ"
      expect(page).to have_selector "option[value='G014']", text: "カフェ・スイーツ"
      expect(page).to have_selector "option[value='G015']", text: "その他グルメ"
    end

    example "料金の選択肢が正しく設定されていること" do
      expect(page).to have_selector "option[value='']", text: "料金：こだわらない"
      expect(page).to have_selector "option[value='B009']", text: "～500円"
      expect(page).to have_selector "option[value='B010']", text: "501～1000円"
      expect(page).to have_selector "option[value='B011']", text: "1001～1500円"
      expect(page).to have_selector "option[value='B001']", text: "1501～2000円"
      expect(page).to have_selector "option[value='B002']", text: "2001～3000円"
      expect(page).to have_selector "option[value='B003']", text: "3001～4000円"
      expect(page).to have_selector "option[value='B008']", text: "4001～5000円"
      expect(page).to have_selector "option[value='B004']", text: "5001～7000円"
      expect(page).to have_selector "option[value='B005']", text: "7001～10000円"
      expect(page).to have_selector "option[value='B006']", text: "10001～15000円"
      expect(page).to have_selector "option[value='B012']", text: "15001～20000円"
      expect(page).to have_selector "option[value='B013']", text: "20001～30000円"
      expect(page).to have_selector "option[value='B014']", text: "30001円～"
    end
  end
end
