require "rails_helper"

RSpec.describe "Contact Pages", type: :system do
  describe "レイアウト確認" do
    example "お問い合わせ画面の要素が正しく表示されること" do
      visit contact_path
      expect(page).to have_current_path contact_path

      expect(page).to have_selector "h1", text: "お問い合わせ"
      expect(all("p").size).to eq 2
      expect(page).to have_link "TOP"
    end
  end

  describe "機能確認" do
    context "[TOP]ボタンを押下した場合" do
      example "ホーム画面に遷移すること" do
        visit root_path
        click_link "お問い合わせ"
        click_link "TOP"
        expect(page).to have_current_path root_path, ignore_query: true
      end
    end
  end
end
