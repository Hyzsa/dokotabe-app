require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーション" do
    example "FactoryBotのデータがバリデーションを通ること" do
      expect(build(:user)).to be_valid
    end

    example "メールアドレスが空の場合エラーになること" do
      user = build(:user, email: "")
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    example "既に登録済みのメールアドレスの場合エラーになること" do
      create(:user, email: "user@example.com")
      user = build(:user, email: "user@example.com")
      user.valid?
      expect(user.errors[:email]).to include("はすでに存在します")
    end

    example "パスワードが5文字以下の場合エラーになること" do
      user = build(:user, password: "12345", password_confirmation: "12345")
      user.valid?
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
    end

    example "パスワードと確認用パスワードが一致しない場合エラーになること" do
      user = build(:user, password_confirmation: "654321")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end
  end
end
