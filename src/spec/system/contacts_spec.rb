require "rails_helper"

RSpec.describe "Contacts", type: :system do
  context "[TOP]ボタンを押下した場合" do
    example "homeページに遷移すること" do
      visit contact_path
      click_link "top_btn"
      expect(page).to have_selector("img[src$='title.png']")
    end
  end
end
