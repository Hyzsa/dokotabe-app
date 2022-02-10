require "rails_helper"

RSpec.describe "Common Parts", type: :system do
  describe "ヘッダー", js: true do
    let(:user) { create(:user) }

    before { visit root_path }

    context "ログインしていない場合" do
      example "表示されているリンクが正しいこと" do
        expect(page).to have_link "DokoTabeのロゴ", href: root_path
        expect(page).to have_link "ホーム", href: root_path
        expect(page).to have_link "お問い合わせ", href: contact_path
        expect(page).to have_link "ログイン", href: new_user_session_path
        expect(page).to have_no_link "検索履歴", href: search_history_path(user.id)
        expect(page).to have_no_link "アカウント", href: "#"
        expect(page).to have_no_link "設定", href: settings_path
        expect(page).to have_no_link "ログアウト", href: destroy_user_session_path
      end

      context "ロゴ画像をクリックした場合" do
        example "ホーム画面に遷移すること" do
          click_link "DokoTabeのロゴ"
          expect(page).to have_current_path root_path
          expect(page).to have_selector ".active", text: "ホーム"
          expect(page.all(".active").size).to eq 1
        end
      end

      context "ホームタブをクリックした場合" do
        example "ホーム画面に遷移すること" do
          click_link "ホーム"
          expect(page).to have_current_path root_path
          expect(page).to have_selector ".active", text: "ホーム"
          expect(page.all(".active").size).to eq 1
        end
      end

      context "お問い合わせタブをクリックした場合" do
        example "お問い合わせ画面に遷移すること" do
          click_link "お問い合わせ"
          expect(page).to have_current_path contact_path
          expect(page).to have_selector ".active", text: "お問い合わせ"
          expect(page.all(".active").size).to eq 1
        end
      end

      context "ログインタブをクリックした場合" do
        example "ログイン画面に遷移すること" do
          click_link "ログイン"
          expect(page).to have_current_path new_user_session_path
          expect(page).to have_selector ".active", text: "ログイン"
          expect(page.all(".active").size).to eq 1
        end
      end
    end

    context "ログインしている場合" do
      before { log_in_as(user) }

      example "表示されているリンクが正しいこと" do
        expect(page).to have_link "DokoTabeのロゴ", href: root_path
        expect(page).to have_link "ホーム", href: root_path
        expect(page).to have_link "お問い合わせ", href: contact_path
        expect(page).to have_no_link "ログイン", href: new_user_session_path
        expect(page).to have_link "検索履歴", href: search_history_path(user.id)
        expect(page).to have_link "アカウント", href: "#"

        click_link "アカウント"
        expect(page).to have_link "設定", href: settings_path
        expect(page).to have_link "ログアウト", href: destroy_user_session_path
      end

      context "ロゴ画像をクリックした場合" do
        example "ホーム画面に遷移すること" do
          click_link "DokoTabeのロゴ"
          expect(page).to have_current_path root_path
          expect(page).to have_selector ".active", text: "ホーム"
          expect(page.all(".active").size).to eq 1
        end
      end

      context "ホームタブをクリックした場合" do
        example "ホーム画面に遷移すること" do
          click_link "ホーム"
          expect(page).to have_current_path root_path
          expect(page).to have_selector ".active", text: "ホーム"
          expect(page.all(".active").size).to eq 1
        end
      end

      context "お問い合わせタブをクリックした場合" do
        example "お問い合わせ画面に遷移すること" do
          click_link "お問い合わせ"
          expect(page).to have_current_path contact_path
          expect(page).to have_selector ".active", text: "お問い合わせ"
          expect(page.all(".active").size).to eq 1
        end
      end

      context "検索履歴タブをクリックした場合" do
        example "検索履歴画面に遷移すること" do
          click_link "検索履歴"
          expect(page).to have_current_path search_history_path(user.id)
          expect(page).to have_selector ".active", text: "検索履歴"
          expect(page.all(".active").size).to eq 1
        end
      end

      context "アカウントタブをクリックした場合" do
        example "ドロップダウンを展開すること" do
          expect(page).to have_no_link "設定", href: settings_path
          expect(page).to have_no_link "ログアウト", href: destroy_user_session_path

          click_link "アカウント"
          expect(page).to have_link "設定", href: settings_path
          expect(page).to have_link "ログアウト", href: destroy_user_session_path
        end
      end

      context "設定タブをクリックした場合" do
        example "設定画面に遷移すること" do
          click_link "アカウント"
          click_link "設定"
          expect(page).to have_current_path settings_path
          expect(page).to have_selector ".active", text: "アカウント"
          # 設定画面はリストタブが設置してあるため、activeクラスは計2つになる。
          expect(page.all(".active").size).to eq 2
        end
      end

      context "ログアウトタブをクリックした場合" do
        example "ログアウトすること" do
          click_link "アカウント"
          click_link "ログアウト"
          expect(page).to have_current_path root_path
          expect(page).to have_content "ログアウトしました。"
          expect(page).to have_selector ".active", text: "ホーム"
          expect(page.all(".active").size).to eq 1
        end
      end
    end
  end
end
