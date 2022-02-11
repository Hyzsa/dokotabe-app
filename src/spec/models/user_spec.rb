require "rails_helper"

RSpec.describe User, type: :model do
  example "正しいデータだと登録できること" do
    user = build(:user)
    expect(user.save).to be_truthy
  end

  describe "バリデーション" do
    example "メールアドレスが空だと登録できないこと" do
      user = build(:user, email: "")
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    example "登録済みのメールアドレスだと登録できないこと" do
      create(:user, email: "user@example.com")
      user = build(:user, email: "user@example.com")
      user.valid?
      expect(user.errors[:email]).to include("はすでに存在します")
    end

    example "パスワードが5文字以下だと登録できないこと" do
      user = build(:user, password: "12345", password_confirmation: "12345")
      user.valid?
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
    end

    example "パスワードと確認用パスワードが不一致だと登録できないこと" do
      user = build(:user, password_confirmation: "654321")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end
  end
end
