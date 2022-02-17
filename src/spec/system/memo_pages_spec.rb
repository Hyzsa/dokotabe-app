require "rails_helper"

RSpec.describe "Memo Pages", type: :system do
  let(:user) { create(:user) }

  describe "レイアウト確認" do
    example "メモ一覧画面の要素が正しく表示されること" do
      favorite = create(:favorite, user_id: user.id)
      memo = create(:memo, favorite_id: favorite.id)

      # お気に入りに紐づいている店舗情報を取得する。
      shop_info = SearchHistory.find(favorite.search_history_id)

      log_in_as(user)

      click_link "お気に入り", href: favorite_path(user)
      click_link "Memo", href: favorite_memos_path(favorite)
      expect(page).to have_current_path favorite_memos_path(favorite)

      expect(all(".title-box").size).to eq 1
      expect(page).to have_selector ".title-box .shop-photo img"
      expect(page).to have_selector ".title-box p", text: "店舗名："
      expect(page).to have_link shop_info.shop_name, href: shop_info.shop_url
      expect(page).to have_selector ".title-box .credit", text: "【画像提供：ホットペッパー グルメ】"

      expect(page).to have_selector "form[method=post]"
      expect(page).to have_selector "form[method=post] textarea"
      expect(page).to have_selector "button", text: "メモ"

      expect(all(".memo").size).to eq 1
      expect(page).to have_link "", href: favorite_memo_path(memo.favorite_id, memo)
    end
  end

  describe "ページネーション" do
    before { log_in_as(user) }

    describe "表示確認" do
      context "メモが10件より多くある場合" do
        example "ページネーションが表示されること" do
          favorite = create(:favorite, user_id: user.id)
          create_list(:memo, 11, favorite_id: favorite.id)

          click_link "お気に入り", href: favorite_path(user)
          click_link "Memo", href: favorite_memos_path(favorite)
          expect(page).to have_current_path favorite_memos_path(favorite)
          expect(page).to have_selector ".pagination"
        end
      end

      context "メモが10件以下の場合" do
        example "ページネーションが表示されないこと" do
          favorite = create(:favorite, user_id: user.id)
          create_list(:memo, 10, favorite_id: favorite.id)

          click_link "お気に入り", href: favorite_path(user)
          click_link "Memo", href: favorite_memos_path(favorite)
          expect(page).to have_current_path favorite_memos_path(favorite)
          expect(page).to have_no_selector ".pagination"
        end
      end
    end

    describe "遷移確認" do
      example "ページネーションの遷移処理に問題がないこと" do
        favorite = create(:favorite, user_id: user.id)
        create_list(:memo, 15, favorite_id: favorite.id)

        click_link "お気に入り", href: favorite_path(user)
        click_link "Memo", href: favorite_memos_path(favorite)
        expect(page).to have_current_path favorite_memos_path(favorite)
        expect(page).to have_selector ".pagination"

        # ページネーションの表示状態を確認する
        expect(all(".memo").size).to eq(10)
        expect(page).to have_no_link "«", href: favorite_memos_path(favorite)
        expect(page).to have_no_link "‹", href: favorite_memos_path(favorite)
        expect(page).to have_selector ".page-item.active", text: "1"
        expect(page).to have_link "2", href: favorite_memos_path(favorite, page: 2)
        expect(page).to have_link "›", href: favorite_memos_path(favorite, page: 2)
        expect(page).to have_link "»", href: favorite_memos_path(favorite, page: 2)

        # ページネーションの[2]ボタンをクリックし、次ページに遷移する
        click_link("2")
        expect(page).to have_current_path favorite_memos_path(favorite, page: 2)

        # ページネーションの表示状態を確認する
        expect(all(".memo").size).to eq(5)
        expect(page).to have_link "«", href: favorite_memos_path(favorite)
        expect(page).to have_link "‹", href: favorite_memos_path(favorite)
        expect(page).to have_link "1", href: favorite_memos_path(favorite)
        expect(page).to have_selector ".page-item.active", text: "2"
        expect(page).to have_no_link "›", href: favorite_memos_path(favorite, page: 2)
        expect(page).to have_no_link "»", href: favorite_memos_path(favorite, page: 2)

        # ページネーションの[1]ボタンをクリックし、前ページに遷移する
        click_link("1")
        expect(page).to have_current_path favorite_memos_path(favorite)

        # ページネーションの表示状態を確認する
        expect(all(".memo").size).to eq(10)
        expect(page).to have_no_link "«", href: favorite_memos_path(favorite)
        expect(page).to have_no_link "‹", href: favorite_memos_path(favorite)
        expect(page).to have_selector ".page-item.active", text: "1"
        expect(page).to have_link "2", href: favorite_memos_path(favorite, page: 2)
        expect(page).to have_link "›", href: favorite_memos_path(favorite, page: 2)
        expect(page).to have_link "»", href: favorite_memos_path(favorite, page: 2)

        # ページネーションの[›]ボタンをクリックし、次ページに遷移する
        click_link("›")
        expect(page).to have_current_path favorite_memos_path(favorite, page: 2)

        # ページネーションの表示状態を確認する
        expect(all(".memo").size).to eq(5)
        expect(page).to have_link "«", href: favorite_memos_path(favorite)
        expect(page).to have_link "‹", href: favorite_memos_path(favorite)
        expect(page).to have_link "1", href: favorite_memos_path(favorite)
        expect(page).to have_selector ".page-item.active", text: "2"
        expect(page).to have_no_link "›", href: favorite_memos_path(favorite, page: 2)
        expect(page).to have_no_link "»", href: favorite_memos_path(favorite, page: 2)

        # ページネーションの[‹]ボタンをクリックし、前ページに遷移する
        click_link("‹")
        expect(page).to have_current_path favorite_memos_path(favorite)

        # ページネーションの表示状態を確認する
        expect(all(".memo").size).to eq(10)
        expect(page).to have_no_link "«", href: favorite_memos_path(favorite)
        expect(page).to have_no_link "‹", href: favorite_memos_path(favorite)
        expect(page).to have_selector ".page-item.active", text: "1"
        expect(page).to have_link "2", href: favorite_memos_path(favorite, page: 2)
        expect(page).to have_link "›", href: favorite_memos_path(favorite, page: 2)
        expect(page).to have_link "»", href: favorite_memos_path(favorite, page: 2)

        # ページネーションの[»]ボタンをクリックし、次ページに遷移する
        click_link("»")
        expect(page).to have_current_path favorite_memos_path(favorite, page: 2)

        # ページネーションの表示状態を確認する
        expect(all(".memo").size).to eq(5)
        expect(page).to have_link "«", href: favorite_memos_path(favorite)
        expect(page).to have_link "‹", href: favorite_memos_path(favorite)
        expect(page).to have_link "1", href: favorite_memos_path(favorite)
        expect(page).to have_selector ".page-item.active", text: "2"
        expect(page).to have_no_link "›", href: favorite_memos_path(favorite, page: 2)
        expect(page).to have_no_link "»", href: favorite_memos_path(favorite, page: 2)

        # ページネーションの[«]ボタンをクリックし、前ページに遷移する
        click_link("«")
        expect(page).to have_current_path favorite_memos_path(favorite)

        # ページネーションの表示状態を確認する
        expect(all(".memo").size).to eq(10)
        expect(page).to have_no_link "«", href: favorite_memos_path(favorite)
        expect(page).to have_no_link "‹", href: favorite_memos_path(favorite)
        expect(page).to have_selector ".page-item.active", text: "1"
        expect(page).to have_link "2", href: favorite_memos_path(favorite, page: 2)
        expect(page).to have_link "›", href: favorite_memos_path(favorite, page: 2)
        expect(page).to have_link "»", href: favorite_memos_path(favorite, page: 2)
      end
    end
  end

  describe "メモ機能" do
    before { log_in_as(user) }

    example "メモの新規作成ができること" do
      favorite = create(:favorite, user_id: user.id)

      click_link "お気に入り", href: favorite_path(user)
      click_link "Memo", href: favorite_memos_path(favorite)
      expect(page).to have_current_path favorite_memos_path(favorite)

      # 何も入力せずにメモボタンを押下する。
      expect { click_button "メモ" }.to change { Memo.count }.by(0)
      expect(page).to have_content "メモを入力してください"

      # 141文字以上入力してメモボタンを押下する。
      text = "a" * 141
      fill_in "memo[content]", with: text
      expect { click_button "メモ" }.to change { Memo.count }.by(0)
      expect(page).to have_content "メモは140文字以内で入力してください"

      # 140文字入力してメモボタンを押下する。
      text = "a" * 140
      fill_in "memo[content]", with: text
      expect { click_button "メモ" }.to change { Memo.count }.by(1)
      expect(all(".memo").size).to eq(1)
    end

    example "メモの削除ができること", js: true do
      favorite = create(:favorite, user_id: user.id)
      memo = create(:memo, favorite_id: favorite.id)

      click_link "お気に入り", href: favorite_path(user)
      click_link "Memo", href: favorite_memos_path(favorite)
      expect(page).to have_current_path favorite_memos_path(favorite)
      expect(all(".memo").size).to eq(1)

      # メモ削除ボタンを押下する。
      expect do
        # 削除確認で[キャンセル]を選択する。
        dismiss_confirm("本当に削除しますか？") do
          click_link "", href: favorite_memo_path(memo.favorite_id, memo)
        end
        sleep(0.5) # 処理待ち
        expect(all(".memo").size).to eq(1)
      end.to change { Memo.count }.by(0)

      expect do
        # 削除確認で[OK]を選択する。
        accept_confirm("本当に削除しますか？") do
          click_link "", href: favorite_memo_path(memo.favorite_id, memo)
        end
        sleep(0.5) # 処理待ち
        expect(all(".memo").size).to eq(0)
      end.to change { Memo.count }.by(-1)
    end

    example "メモが他のお気に入りに干渉しないこと" do
      favorites = create_list(:favorite, 2, user_id: user.id)

      click_link "お気に入り", href: favorite_path(user)
      click_link "Memo", href: favorite_memos_path(favorites[0])
      expect(page).to have_current_path favorite_memos_path(favorites[0])

      # メモを作成する。
      text = "a" * 140
      fill_in "memo[content]", with: text
      expect { click_button "メモ" }.to change { Memo.count }.by(1)
      expect(all(".memo").size).to eq(1)

      # 別店舗のメモ一覧画面に遷移する。
      click_link "お気に入り", href: favorite_path(user)
      click_link "Memo", href: favorite_memos_path(favorites[1])
      expect(page).to have_current_path favorite_memos_path(favorites[1])

      # メモ数を確認する。
      expect(all(".memo").size).to eq(0)
    end
  end
end
