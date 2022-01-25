require "rails_helper"

RSpec.describe "Contact Pages", type: :system do
  context "[TOP]ボタンを押下した場合" do
    example "homeページに遷移すること" do
      visit contact_path
      click_link "top_btn"
      expect(page).to have_current_path root_path, ignore_query: true
    end
  end
end
