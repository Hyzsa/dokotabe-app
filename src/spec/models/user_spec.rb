require "rails_helper"

RSpec.describe User, type: :model do
  example "正しいデータであれば登録できること" do
    user = FactoryBot.build(:user)
    expect(user.save).to be_truthy
  end

  describe "バリデーション" do
    example "メールアドレスが空では登録できないこと" do
      user = FactoryBot.build(:user, email: "")
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    example "既に登録されているメールアドレスでは登録できないこと" do
      FactoryBot.create(:user)
      user = FactoryBot.build(:user)
      user.valid?
      expect(user.errors[:email]).to include("はすでに存在します")
    end

    example "パスワードが6文字より短ければ登録できないこと" do
      user = FactoryBot.build(:user, password: "12345", password_confirmation: "12345")
      user.valid?
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
    end

    example "パスワードと確認用パスワードが一致しなければ登録できないこと" do
      user = FactoryBot.build(:user, password_confirmation: "654321")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end
  end
end
