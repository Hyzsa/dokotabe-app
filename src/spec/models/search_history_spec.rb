require "rails_helper"

RSpec.describe SearchHistory, type: :model do
  example "正しいデータだと登録できること" do
    histories = create(:user).search_histories.build
    expect(histories.save).to be_truthy
  end
end
