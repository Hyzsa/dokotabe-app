require 'rails_helper'

RSpec.describe Memo, type: :model do
  describe "バリデーション" do
    example "FactoryBotのデータがバリデーションを通ること" do
      expect(build(:memo)).to be_valid
    end

    example "contentが空の場合エラーになること" do
      memo = build(:memo, content: "")
      expect(memo).to be_invalid
    end

    example "contentが半角140文字の場合エラーにならないこと" do
      content = "a" * 140
      memo = build(:memo, content: content)
      expect(memo).to be_valid
    end

    example "contentが半角141文字以上の場合エラーになること" do
      content = "a" * 141
      memo = build(:memo, content: content)
      expect(memo).to be_invalid
    end

    example "contentが全角140文字の場合エラーにならないこと" do
      content = "あ" * 140
      memo = build(:memo, content: content)
      expect(memo).to be_valid
    end

    example "contentが全角141文字以上の場合エラーになること" do
      content = "あ" * 141
      memo = build(:memo, content: content)
      expect(memo).to be_invalid
    end
  end
end
