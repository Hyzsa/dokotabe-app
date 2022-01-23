require "rails_helper"

RSpec.describe "Common Parts", type: :system do
  describe "header" do
    shared_examples "homeページに遷移すること" do |id|
      example do
        visit root_path
        click_link(id.to_s)
        expect(page).to have_selector("img[src$='title.png']")
      end
    end

    shared_examples "activeクラスの設定箇所が正しいこと" do |id|
      example "クリックしたタブにactiveクラスが設定されていること" do
        visit root_path
        click_link(id.to_s)
        expect(page).to have_selector "##{id}", class: "active"
      end

      example "activeクラスがページ内で1箇所だけ設定されていること" do
        visit root_path
        click_link(id.to_s)
        expect(page.all(".active").size).to eq 1
      end
    end

    context "ロゴ画像をクリックした場合" do
      it_behaves_like "homeページに遷移すること", :logo
      it_behaves_like "activeクラスの設定箇所が正しいこと", :home
    end

    context "ホームタブをクリックした場合" do
      it_behaves_like "homeページに遷移すること", :home
      it_behaves_like "activeクラスの設定箇所が正しいこと", :home
    end

    context "お問い合わせタブをクリックした場合" do
      example "contactページに遷移すること" do
        visit root_path
        click_link("contact")
        expect(page).to have_selector "h1", text: "お問い合わせ"
      end

      it_behaves_like "activeクラスの設定箇所が正しいこと", :contact
    end
  end
end
