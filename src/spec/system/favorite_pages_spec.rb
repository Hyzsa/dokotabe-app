require "rails_helper"

RSpec.describe "favorite", type: :system do
  let(:user) { create(:user) }

  describe "レイアウト確認" do
    context "お気に入りに何も登録されていない場合" do
      example "お気に入り画面の要素が正しく表示されること" do
        log_in_as(user)

        click_link "お気に入り", href: favorite_path
        expect(page).to have_current_path favorite_path
        expect(page).to have_selector "h1", text: "お気に入り店舗"
        expect(page).to have_link "検索履歴画面", href: search_history_path(user.id)
      end
    end

    context "お気に入りに登録されている場合" do
      example "お気に入り画面の要素が正しく表示されること" do
        history = create(:search_history, user_id: user.id)
        create(:favorite, user_id: user.id, search_history_id: history.id, shop_id: history.shop_id)

        # ユーザがお気に入りしている店舗を取得する
        dependent_shops = user.favorite_shops

        log_in_as(user)

        click_link "お気に入り", href: favorite_path
        expect(page).to have_current_path favorite_path
        expect(page).to have_no_selector "h1", text: "お気に入り店舗"
        expect(page).to have_selector ".history-photo img"
        expect(page).to have_link "", href: favorite_path(history_id: dependent_shops[0].id, redirect: true)
        expect(page).to have_selector "p", text: "店舗名："
        expect(page).to have_link dependent_shops[0].shop_name.to_s, href: dependent_shops[0].shop_url
        expect(page).to have_link "Memo", href: "#"
        expect(page).to have_selector "p", text: "【画像提供：ホットペッパー グルメ】"
      end
    end
  end

  describe "ページネーション" do
    before { log_in_as(user) }

    describe "表示確認" do
      context "お気に入りが10件より多くある場合" do
        example "ページネーションが表示されること" do
          histories = create_list(:search_history, 11, user_id: user.id)
          histories.each do |history|
            create(:favorite, user_id: user.id, search_history_id: history.id, shop_id: history.shop_id)
          end

          click_link "お気に入り", href: favorite_path
          expect(page).to have_current_path favorite_path
          expect(page).to have_selector ".pagination"
        end
      end

      context "お気に入りが10件以下の場合" do
        example "ページネーションが表示されないこと" do
          histories = create_list(:search_history, 10, user_id: user.id)
          histories.each do |history|
            create(:favorite, user_id: user.id, search_history_id: history.id, shop_id: history.shop_id)
          end

          click_link "お気に入り", href: favorite_path
          expect(page).to have_current_path favorite_path
          expect(page).to have_no_selector ".pagination"
        end
      end
    end

    describe "遷移確認" do
      example "ページネーションの遷移処理に問題がないこと" do
        histories = create_list(:search_history, 15, user_id: user.id)
        histories.each do |history|
          create(:favorite, user_id: user.id, search_history_id: history.id, shop_id: history.shop_id)
        end

        click_link "お気に入り", href: favorite_path
        expect(page).to have_current_path favorite_path
        expect(page).to have_selector ".pagination"

        # ページネーションの表示状態を確認する
        expect(all(".history-photo").size).to eq(10)
        expect(page).to have_no_link "«", href: favorite_path
        expect(page).to have_no_link "‹", href: favorite_path
        expect(page).to have_selector ".page-item.active", text: "1"
        expect(page).to have_link "2", href: favorite_path(page: 2)
        expect(page).to have_link "›", href: favorite_path(page: 2)
        expect(page).to have_link "»", href: favorite_path(page: 2)

        # ページネーションの[2]ボタンをクリックし、次ページに遷移する
        click_link("2")
        expect(page).to have_current_path favorite_path(page: 2)

        # ページネーションの表示状態を確認する
        expect(all(".history-photo").size).to eq(5)
        expect(page).to have_link "«", href: favorite_path
        expect(page).to have_link "‹", href: favorite_path
        expect(page).to have_link "1", href: favorite_path
        expect(page).to have_selector ".page-item.active", text: "2"
        expect(page).to have_no_link "›", href: favorite_path(page: 2)
        expect(page).to have_no_link "»", href: favorite_path(page: 2)

        # ページネーションの[1]ボタンをクリックし、前ページに遷移する
        click_link("1")
        expect(page).to have_current_path favorite_path

        # ページネーションの表示状態を確認する
        expect(all(".history-photo").size).to eq(10)
        expect(page).to have_no_link "«", href: favorite_path
        expect(page).to have_no_link "‹", href: favorite_path
        expect(page).to have_selector ".page-item.active", text: "1"
        expect(page).to have_link "2", href: favorite_path(page: 2)
        expect(page).to have_link "›", href: favorite_path(page: 2)
        expect(page).to have_link "»", href: favorite_path(page: 2)

        # ページネーションの[›]ボタンをクリックし、次ページに遷移する
        click_link("›")
        expect(page).to have_current_path favorite_path(page: 2)

        # ページネーションの表示状態を確認する
        expect(all(".history-photo").size).to eq(5)
        expect(page).to have_link "«", href: favorite_path
        expect(page).to have_link "‹", href: favorite_path
        expect(page).to have_link "1", href: favorite_path
        expect(page).to have_selector ".page-item.active", text: "2"
        expect(page).to have_no_link "›", href: favorite_path(page: 2)
        expect(page).to have_no_link "»", href: favorite_path(page: 2)

        # ページネーションの[‹]ボタンをクリックし、前ページに遷移する
        click_link("‹")
        expect(page).to have_current_path favorite_path

        # ページネーションの表示状態を確認する
        expect(all(".history-photo").size).to eq(10)
        expect(page).to have_no_link "«", href: favorite_path
        expect(page).to have_no_link "‹", href: favorite_path
        expect(page).to have_selector ".page-item.active", text: "1"
        expect(page).to have_link "2", href: favorite_path(page: 2)
        expect(page).to have_link "›", href: favorite_path(page: 2)
        expect(page).to have_link "»", href: favorite_path(page: 2)

        # ページネーションの[»]ボタンをクリックし、次ページに遷移する
        click_link("»")
        expect(page).to have_current_path favorite_path(page: 2)

        # ページネーションの表示状態を確認する
        expect(all(".history-photo").size).to eq(5)
        expect(page).to have_link "«", href: favorite_path
        expect(page).to have_link "‹", href: favorite_path
        expect(page).to have_link "1", href: favorite_path
        expect(page).to have_selector ".page-item.active", text: "2"
        expect(page).to have_no_link "›", href: favorite_path(page: 2)
        expect(page).to have_no_link "»", href: favorite_path(page: 2)

        # ページネーションの[«]ボタンをクリックし、前ページに遷移する
        click_link("«")
        expect(page).to have_current_path favorite_path

        # ページネーションの表示状態を確認する
        expect(all(".history-photo").size).to eq(10)
        expect(page).to have_no_link "«", href: favorite_path
        expect(page).to have_no_link "‹", href: favorite_path
        expect(page).to have_selector ".page-item.active", text: "1"
        expect(page).to have_link "2", href: favorite_path(page: 2)
        expect(page).to have_link "›", href: favorite_path(page: 2)
        expect(page).to have_link "»", href: favorite_path(page: 2)
      end
    end
  end

  describe "お気に入り機能", js: true do
    before { log_in_as(user) }

    example "お気に入りの解除ができること" do
      history = create(:search_history, user_id: user.id)
      favorite = create(:favorite, user_id: user.id, search_history_id: history.id, shop_id: history.shop_id)

      click_link "お気に入り", href: favorite_path
      expect(page).to have_current_path favorite_path
      expect(all(".history-photo").size).to eq(1)

      # お気に入りを解除する
      expect do
        # お気に入りを解除確認で[キャンセル]を選択する
        dismiss_confirm("お気に入りを解除するとメモ情報も完全に削除されます。\n本当に削除しますか？") do
          click_link "", href: favorite_path(history_id: favorite.search_history_id, redirect: true)
        end
        sleep(0.5) # 処理待ち
        expect(all(".history-photo").size).to eq(1)
      end.to change { Favorite.count }.by(0)

      expect do
        # お気に入りを解除確認で[OK]を選択する
        accept_confirm("お気に入りを解除するとメモ情報も完全に削除されます。\n本当に削除しますか？") do
          click_link "", href: favorite_path(history_id: favorite.search_history_id, redirect: true)
        end
        sleep(0.5) # 処理待ち
        expect(all(".history-photo").size).to eq(0)
      end.to change { Favorite.count }.by(-1)
    end
  end
end
