require "rails_helper"

RSpec.describe "Search History", type: :system do
  let(:user) { create(:user) }

  describe "レイアウト確認" do
    example "検索履歴画面の要素が正しく表示されること" do
      history_num = 10; # 履歴の数
      create_list(:search_history, history_num, user_id: user.id)

      log_in_as(user)
      visit search_history_path(user.id)
      expect(page).to have_current_path search_history_path(user.id)

      expect(all(".list-box").size).to eq history_num
      expect(all(".list-box .history-photo").size).to eq history_num
      expect(all(".list-box .credit").size).to eq history_num
    end
  end

  describe "ページネーション" do
    before { log_in_as(user) }

    describe "表示確認" do
      context "検索履歴が10件より多くある場合" do
        example "ページネーションが表示されること" do
          create_list(:search_history, 11, user_id: user.id)

          click_link "検索履歴"
          expect(page).to have_current_path search_history_path(user.id)
          expect(page).to have_selector ".pagination"
        end
      end

      context "検索履歴が10件以下の場合" do
        example "ページネーションが表示されないこと" do
          create_list(:search_history, 10, user_id: user.id)

          click_link "検索履歴"
          expect(page).to have_current_path search_history_path(user.id)
          expect(page).to have_no_selector ".pagination"
        end
      end
    end

    describe "遷移確認" do
      example "ページネーションの遷移処理に問題がないこと" do
        create_list(:search_history, 15, user_id: user.id)

        click_link "検索履歴"
        expect(page).to have_current_path search_history_path(user.id)
        expect(page).to have_selector ".pagination"

        # ページネーションの表示状態を確認する
        expect(all(".history-photo").size).to eq(10)
        expect(page).to have_no_link "«", href: search_history_path(user.id)
        expect(page).to have_no_link "‹", href: search_history_path(user.id)
        expect(page).to have_selector ".page-item.active", text: "1"
        expect(page).to have_link "2", href: search_history_path(user.id, page: 2)
        expect(page).to have_link "›", href: search_history_path(user.id, page: 2)
        expect(page).to have_link "»", href: search_history_path(user.id, page: 2)

        # ページネーションの[2]ボタンをクリックし、次ページに遷移する
        click_link("2")
        expect(page).to have_current_path search_history_path(user.id, page: 2)

        # ページネーションの表示状態を確認する
        expect(all(".history-photo").size).to eq(5)
        expect(page).to have_link "«", href: search_history_path(user.id)
        expect(page).to have_link "‹", href: search_history_path(user.id)
        expect(page).to have_link "1", href: search_history_path(user.id)
        expect(page).to have_selector ".page-item.active", text: "2"
        expect(page).to have_no_link "›", href: search_history_path(user.id, page: 2)
        expect(page).to have_no_link "»", href: search_history_path(user.id, page: 2)

        # ページネーションの[1]ボタンをクリックし、前ページに遷移する
        click_link("1")
        expect(page).to have_current_path search_history_path(user.id)

        # ページネーションの表示状態を確認する
        expect(all(".history-photo").size).to eq(10)
        expect(page).to have_no_link "«", href: search_history_path(user.id)
        expect(page).to have_no_link "‹", href: search_history_path(user.id)
        expect(page).to have_selector ".page-item.active", text: "1"
        expect(page).to have_link "2", href: search_history_path(user.id, page: 2)
        expect(page).to have_link "›", href: search_history_path(user.id, page: 2)
        expect(page).to have_link "»", href: search_history_path(user.id, page: 2)

        # ページネーションの[›]ボタンをクリックし、次ページに遷移する
        click_link("›")
        expect(page).to have_current_path search_history_path(user.id, page: 2)

        # ページネーションの表示状態を確認する
        expect(all(".history-photo").size).to eq(5)
        expect(page).to have_link "«", href: search_history_path(user.id)
        expect(page).to have_link "‹", href: search_history_path(user.id)
        expect(page).to have_link "1", href: search_history_path(user.id)
        expect(page).to have_selector ".page-item.active", text: "2"
        expect(page).to have_no_link "›", href: search_history_path(user.id, page: 2)
        expect(page).to have_no_link "»", href: search_history_path(user.id, page: 2)

        # ページネーションの[‹]ボタンをクリックし、前ページに遷移する
        click_link("‹")
        expect(page).to have_current_path search_history_path(user.id)

        # ページネーションの表示状態を確認する
        expect(all(".history-photo").size).to eq(10)
        expect(page).to have_no_link "«", href: search_history_path(user.id)
        expect(page).to have_no_link "‹", href: search_history_path(user.id)
        expect(page).to have_selector ".page-item.active", text: "1"
        expect(page).to have_link "2", href: search_history_path(user.id, page: 2)
        expect(page).to have_link "›", href: search_history_path(user.id, page: 2)
        expect(page).to have_link "»", href: search_history_path(user.id, page: 2)

        # ページネーションの[»]ボタンをクリックし、次ページに遷移する
        click_link("»")
        expect(page).to have_current_path search_history_path(user.id, page: 2)

        # ページネーションの表示状態を確認する
        expect(all(".history-photo").size).to eq(5)
        expect(page).to have_link "«", href: search_history_path(user.id)
        expect(page).to have_link "‹", href: search_history_path(user.id)
        expect(page).to have_link "1", href: search_history_path(user.id)
        expect(page).to have_selector ".page-item.active", text: "2"
        expect(page).to have_no_link "›", href: search_history_path(user.id, page: 2)
        expect(page).to have_no_link "»", href: search_history_path(user.id, page: 2)

        # ページネーションの[«]ボタンをクリックし、前ページに遷移する
        click_link("«")
        expect(page).to have_current_path search_history_path(user.id)

        # ページネーションの表示状態を確認する
        expect(all(".history-photo").size).to eq(10)
        expect(page).to have_no_link "«", href: search_history_path(user.id)
        expect(page).to have_no_link "‹", href: search_history_path(user.id)
        expect(page).to have_selector ".page-item.active", text: "1"
        expect(page).to have_link "2", href: search_history_path(user.id, page: 2)
        expect(page).to have_link "›", href: search_history_path(user.id, page: 2)
        expect(page).to have_link "»", href: search_history_path(user.id, page: 2)
      end
    end
  end

  describe "お気に入り機能", js: true do
    example "お気に入り機能が正常に動作すること" do
      user1 = create(:user)
      u1_history_list_1 = create_list(:search_history, 5, user_id: user1.id, shop_id: "J000000001" )
      u1_history_list_2 = create_list(:search_history, 5, user_id: user1.id, shop_id: "J000000002" )

      user2 = create(:user)
      u2_history_list_1 = create_list(:search_history, 5, user_id: user2.id, shop_id: "J000000001" )
      u2_history_list_2 = create_list(:search_history, 5, user_id: user2.id, shop_id: "J000000002" )

      # ユーザー1でログインする
      log_in_as(user1)

      click_link "検索履歴"
      expect(page).to have_current_path search_history_path(user1.id)

      # お気に入り設定用のリンクがあることを確認する
      5.times do |n|
        expect(page).to have_link "", href: favorite_path(history_id: u1_history_list_1[n].id)
        expect(page).to have_link "", href: favorite_path(history_id: u1_history_list_2[n].id)
      end

      # お気に入り状態を確認する
      expect(all("a[data-method=post]").size).to eq 10
      expect(all("a[data-method=delete]").size).to eq 0
      expect(all(".favorite").size).to eq 0

      # 1番目に表示されている店舗をお気に入りに登録する
      click_link "", href: favorite_path(history_id: u1_history_list_1[0].id)
      sleep(0.5)  # ajax処理待ち

      # 同店舗の履歴がお気に入り状態になることを確認する
      expect(all("a[data-method=post]").size).to eq 5
      expect(all("a[data-method=delete]").size).to eq 5
      expect(all(".favorite").size).to eq 5

      # 1番目と同じ店舗のお気に入りを解除する
      click_link "", href: favorite_path(history_id: u1_history_list_1[1].id)
      sleep(0.5)  # ajax処理待ち

      # 同店舗の履歴がお気に入り状態から解除されることを確認する
      expect(all("a[data-method=post]").size).to eq 10
      expect(all("a[data-method=delete]").size).to eq 0
      expect(all(".favorite").size).to eq 0

      # 全店舗お気に入り状態にする
      click_link "", href: favorite_path(history_id: u1_history_list_1[0].id)
      click_link "", href: favorite_path(history_id: u1_history_list_2[0].id)
      sleep(0.5)  # ajax処理待ち

      expect(all("a[data-method=post]").size).to eq 0
      expect(all("a[data-method=delete]").size).to eq 10
      expect(all(".favorite").size).to eq 10

      # ユーザー2のお気に入り状態に影響していないことを確認する
      click_link "アカウント"
      click_link "ログアウト"

      log_in_as(user2)

      click_link "検索履歴"
      expect(page).to have_current_path search_history_path(user2.id)

      5.times do |n|
        expect(page).to have_link "", href: favorite_path(history_id: u2_history_list_1[n].id)
        expect(page).to have_link "", href: favorite_path(history_id: u2_history_list_2[n].id)
      end

      expect(all("a[data-method=post]").size).to eq 10
      expect(all("a[data-method=delete]").size).to eq 0
      expect(all(".favorite").size).to eq 0
    end
  end
end
