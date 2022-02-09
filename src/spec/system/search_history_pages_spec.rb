require "rails_helper"

RSpec.describe "Search History", type: :system do
  let(:user) { create(:user) }

  before do
    visit root_path
    click_link "ログイン"
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
  end

  describe "ページネーション" do
    describe "表示確認" do
      context "検索履歴が10件より多くある場合" do
        example "ページネーションが表示されること" do
          create_list(:search_history, 11, user_id: user.id)

          click_link "検索履歴"
          expect(page).to have_current_path search_history_path(user.id), ignore_query: true
          expect(page).to have_selector ".pagination"
        end
      end

      context "検索履歴が10件以下の場合" do
        example "ページネーションが表示されないこと" do
          create_list(:search_history, 10, user_id: user.id)

          click_link "検索履歴"
          expect(page).to have_current_path search_history_path(user.id), ignore_query: true
          expect(page).to_not have_selector ".pagination"
        end
      end
    end

    describe "遷移確認" do
      example "ページネーションの遷移処理に問題がないこと" do
        create_list(:search_history, 15, user_id: user.id)

        click_link "検索履歴"
        expect(page).to have_current_path search_history_path(user.id), ignore_query: true
        expect(page).to have_selector ".pagination"

        # ページネーションの表示状態を確認する
        expect(all(".search-histories-shop-photo").size).to eq(10)
        expect(page).to_not have_link "«", href: search_history_path(user.id)
        expect(page).to_not have_link "‹", href: search_history_path(user.id)
        expect(page).to have_selector ".page-item.active", text: "1"
        expect(page).to have_link "2", href: search_history_path(user.id, page: 2)
        expect(page).to have_link "›", href: search_history_path(user.id, page: 2)
        expect(page).to have_link "»", href: search_history_path(user.id, page: 2)

        # ページネーションの[2]ボタンをクリックし、次ページに遷移する
        click_link("2")
        expect(page).to have_current_path search_history_path(user.id, page: 2)

        # ページネーションの表示状態を確認する
        expect(all(".search-histories-shop-photo").size).to eq(5)
        expect(page).to have_link "«", href: search_history_path(user.id)
        expect(page).to have_link "‹", href: search_history_path(user.id)
        expect(page).to have_link "1", href: search_history_path(user.id)
        expect(page).to have_selector ".page-item.active", text: "2"
        expect(page).to_not have_link "›", href: search_history_path(user.id, page: 2)
        expect(page).to_not have_link "»", href: search_history_path(user.id, page: 2)

        # ページネーションの[1]ボタンをクリックし、前ページに遷移する
        click_link("1")
        expect(page).to have_current_path search_history_path(user.id)

        # ページネーションの表示状態を確認する
        expect(all(".search-histories-shop-photo").size).to eq(10)
        expect(page).to_not have_link "«", href: search_history_path(user.id)
        expect(page).to_not have_link "‹", href: search_history_path(user.id)
        expect(page).to have_selector ".page-item.active", text: "1"
        expect(page).to have_link "2", href: search_history_path(user.id, page: 2)
        expect(page).to have_link "›", href: search_history_path(user.id, page: 2)
        expect(page).to have_link "»", href: search_history_path(user.id, page: 2)

        # ページネーションの[›]ボタンをクリックし、次ページに遷移する
        click_link("›")
        expect(page).to have_current_path search_history_path(user.id, page: 2)

        # ページネーションの表示状態を確認する
        expect(all(".search-histories-shop-photo").size).to eq(5)
        expect(page).to have_link "«", href: search_history_path(user.id)
        expect(page).to have_link "‹", href: search_history_path(user.id)
        expect(page).to have_link "1", href: search_history_path(user.id)
        expect(page).to have_selector ".page-item.active", text: "2"
        expect(page).to_not have_link "›", href: search_history_path(user.id, page: 2)
        expect(page).to_not have_link "»", href: search_history_path(user.id, page: 2)

        # ページネーションの[‹]ボタンをクリックし、前ページに遷移する
        click_link("‹")
        expect(page).to have_current_path search_history_path(user.id)

        # ページネーションの表示状態を確認する
        expect(all(".search-histories-shop-photo").size).to eq(10)
        expect(page).to_not have_link "«", href: search_history_path(user.id)
        expect(page).to_not have_link "‹", href: search_history_path(user.id)
        expect(page).to have_selector ".page-item.active", text: "1"
        expect(page).to have_link "2", href: search_history_path(user.id, page: 2)
        expect(page).to have_link "›", href: search_history_path(user.id, page: 2)
        expect(page).to have_link "»", href: search_history_path(user.id, page: 2)

        # ページネーションの[»]ボタンをクリックし、次ページに遷移する
        click_link("»")
        expect(page).to have_current_path search_history_path(user.id, page: 2)

        # ページネーションの表示状態を確認する
        expect(all(".search-histories-shop-photo").size).to eq(5)
        expect(page).to have_link "«", href: search_history_path(user.id)
        expect(page).to have_link "‹", href: search_history_path(user.id)
        expect(page).to have_link "1", href: search_history_path(user.id)
        expect(page).to have_selector ".page-item.active", text: "2"
        expect(page).to_not have_link "›", href: search_history_path(user.id, page: 2)
        expect(page).to_not have_link "»", href: search_history_path(user.id, page: 2)

        # ページネーションの[«]ボタンをクリックし、前ページに遷移する
        click_link("«")
        expect(page).to have_current_path search_history_path(user.id)

        # ページネーションの表示状態を確認する
        expect(all(".search-histories-shop-photo").size).to eq(10)
        expect(page).to_not have_link "«", href: search_history_path(user.id)
        expect(page).to_not have_link "‹", href: search_history_path(user.id)
        expect(page).to have_selector ".page-item.active", text: "1"
        expect(page).to have_link "2", href: search_history_path(user.id, page: 2)
        expect(page).to have_link "›", href: search_history_path(user.id, page: 2)
        expect(page).to have_link "»", href: search_history_path(user.id, page: 2)
      end
    end
  end
end
