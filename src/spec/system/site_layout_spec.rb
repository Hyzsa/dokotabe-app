require "rails_helper"

RSpec.describe "Homes", type: :system do
  # shared_examples
  RSpec.shared_examples "go to home page" do |id|
    it "homeページに遷移すること" do
      visit root_path
      click_link(id.to_s)
      expect(page).to have_selector("img[src$='title.png']")
    end
  end

  RSpec.shared_examples "active class setting location" do |id|
    it "activeクラスの設定箇所が正しいこと" do
      visit root_path
      click_link(id.to_s)
      expect(page).to have_selector "##{id}", class: "active"
    end

    it "activeクラスがページ内で1箇所だけ設定されていること" do
      visit root_path
      click_link(id.to_s)
      expect(page.all(".active").size).to eq 1
    end
  end

  # spec
  describe "header" do
    # [ロゴ画像]をクリックした場合
    context "when you click logo" do
      it_behaves_like "go to home page", :logo
      it_behaves_like "active class setting location", :home
    end

    # [ホーム]をクリックした場合
    context "when you click home" do
      it_behaves_like "go to home page", :home
      it_behaves_like "active class setting location", :home
    end

    # [お問い合わせ]をクリックした場合
    context "when you click contact" do
      it "contactページに遷移すること" do
        visit root_path
        click_link("contact")
        expect(page).to have_content("StaticPages#contact")
      end

      it_behaves_like "active class setting location", :contact
    end
  end
end
