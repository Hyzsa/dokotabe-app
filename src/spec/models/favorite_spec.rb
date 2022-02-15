require "rails_helper"

RSpec.describe Favorite, type: :model do
  describe "バリデーション" do
    example "FactoryBotのデータがバリデーションを通ること" do
      expect(build(:favorite)).to be_valid
    end

    example "shop_idが空の場合エラーになること" do
      favorite = build(:favorite, shop_id: "")
      expect(favorite).to be_invalid
    end

    example "shop_idが既に登録済みの場合エラーになること" do
      user = create(:user)
      histories = create_list(:search_history, 2, user_id: user.id, shop_id: "J0001")
      create(:favorite, user_id: user.id, shop_id: histories[0].shop_id)

      favorite = build(:favorite, user_id: user.id, shop_id: histories[1].shop_id)
      expect(favorite).to be_invalid
    end
  end
end
