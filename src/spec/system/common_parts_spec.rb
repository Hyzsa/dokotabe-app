require "rails_helper"

RSpec.describe "Common Parts", type: :system do
  describe "ヘッダー" do
    before do
      visit root_path
    end

    shared_examples "activeクラスの設定箇所が正しいこと" do |id|
      example "クリックしたタブにactiveクラスが設定されていること" do
        click_link(id.to_s)
        expect(page).to have_selector "##{id}", class: "active"
      end

      example "activeクラスがページ内で1箇所だけ設定されていること" do
        click_link(id.to_s)
        expect(page.all(".active").size).to eq 1
      end
    end

    context "ロゴ画像をクリックした場合" do
      example "ホーム画面に遷移すること" do
        click_link "DokoTabeのロゴ"
        expect(page).to have_current_path root_path, ignore_query: true
      end

      it_behaves_like "activeクラスの設定箇所が正しいこと", :home
    end

    context "ホームタブをクリックした場合" do
      example "ホーム画面に遷移すること" do
        click_link "ホーム"
        expect(page).to have_current_path root_path, ignore_query: true
      end

      it_behaves_like "activeクラスの設定箇所が正しいこと", :home
    end

    context "お問い合わせタブをクリックした場合" do
      example "お問い合わせ画面に遷移すること" do
        click_link "お問い合わせ"
        expect(page).to have_current_path contact_path, ignore_query: true
      end

      it_behaves_like "activeクラスの設定箇所が正しいこと", :contact
    end

    context "ログインタブをクリックした場合" do
      example "ログイン画面に遷移すること" do
        click_link "ログイン"
        expect(page).to have_current_path new_user_session_path, ignore_query: true
      end

      it_behaves_like "activeクラスの設定箇所が正しいこと", :login
    end
  end
end
