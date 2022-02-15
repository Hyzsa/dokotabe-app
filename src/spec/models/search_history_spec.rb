require "rails_helper"

RSpec.describe SearchHistory, type: :model do
  describe "バリデーション" do
    example "FactoryBotのデータがバリデーションを通ること" do
      expect(build(:search_history)).to be_valid
    end

    example "shop_idが空の場合エラーになること" do
      history = build(:search_history, shop_id: "")
      expect(history).to be_invalid
    end

    example "shop_nameが空の場合エラーになること" do
      history = build(:search_history, shop_name: "")
      expect(history).to be_invalid
    end

    example "shop_photoが空の場合エラーになること" do
      history = build(:search_history, shop_photo: "")
      expect(history).to be_invalid
    end

    example "shop_photoがURL以外の場合エラーになること" do
      history = build(:search_history, shop_photo: "shop_photo")
      expect(history).to be_invalid
    end

    example "displayed_dateが空の場合エラーになること" do
      history = build(:search_history, displayed_date: "")
      expect(history).to be_invalid
    end

    example "shop_urlが空の場合エラーになること" do
      history = build(:search_history, shop_url: "")
      expect(history).to be_invalid
    end

    example "shop_urlがURL以外の場合エラーになること" do
      history = build(:search_history, shop_url: "shop_url")
      expect(history).to be_invalid
    end
  end
end
