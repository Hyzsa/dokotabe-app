require "rails_helper"

RSpec.describe DisplayedShop, type: :model do
  example "正しいデータであれば登録できること" do
    histories = create(:user).displayed_shops.build
    expect(histories.save).to be_truthy
  end
end
