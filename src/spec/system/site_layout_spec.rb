require 'rails_helper'

RSpec.describe "Homes", type: :system do
  # shared_examples
  RSpec.shared_examples :go_to_home_page do |id|
    scenario "homeページに遷移すること" do
      visit root_path
      click_link("#{id}")
      expect(page).to have_selector("img[src$='title.png']")
    end
  end

  RSpec.shared_examples :active_class_setting_location do |id|
    scenario "activeクラスの設定箇所が正しいこと" do
      visit root_path
      click_link("#{id}")
      expect(page).to have_selector "##{id}", class: "active"
      expect(page.all(".active").size).to eq 1
    end
  end

  # spec
  describe "header" do
    # [ロゴ画像]をクリックした場合
    context "click logo" do
      it_behaves_like :go_to_home_page, :logo
      it_behaves_like :active_class_setting_location, :home
    end

    # [ホーム]をクリックした場合
    context "click home" do
      it_behaves_like :go_to_home_page, :home
      it_behaves_like :active_class_setting_location, :home
    end

    # [お問い合わせ]をクリックした場合
    context "click contact" do
      scenario "contactページに遷移すること" do
        visit root_path
        click_link("contact")
        expect(page).to have_content("StaticPages#contact")
      end
      it_behaves_like :active_class_setting_location, :contact
    end
  end
end
