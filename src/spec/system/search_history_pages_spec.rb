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

      expect(page).to have_selector "h1", text: "検索履歴"
      expect(all("li > .history-photo").size).to eq history_num
      history_num.times do
        expect(page).to have_selector "li p", text: "日付　："
        expect(page).to have_selector "li p", text: "店舗名："
      end
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
end
