require "rails_helper"

RSpec.describe "Contact Pages", type: :system do
  context "[TOP]ボタンを押下した場合" do
    example "ホーム画面に遷移すること" do
      visit root_path
      click_link "お問い合わせ"
      click_link "TOP"
      expect(page).to have_current_path root_path, ignore_query: true
    end
  end
end
