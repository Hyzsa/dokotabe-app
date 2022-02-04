require "rails_helper"

RSpec.describe "Registrations", type: :system do
  before do
    ActionMailer::Base.deliveries.clear
    visit root_path
    expect(page).to have_http_status(:success)
  end

  def extract_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end

  def fill_in_signup_form(new_user)
    fill_in "メールアドレス", with: new_user.email
    fill_in "パスワード", with: new_user.password
    fill_in "パスワード（確認用）", with: new_user.password_confirmation
  end

  def fill_in_login_form(user)
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
  end

  context "新規登録フォームへの入力値が有効な場合" do
    context "本人確認を行っていない場合" do
      example "ログインできないこと" do
        click_link "ログイン"
        click_link "アカウントの新規登録はこちら"

        # アカウントを新規登録する
        user = build(:user, confirmed_at: nil)
        fill_in_signup_form(user)
        expect { click_button "アカウントを作成" }.to \
          change { ActionMailer::Base.deliveries.size }.by(1).and \
          change { User.all.size }.by(1)
        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).to have_content "本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。"

        # ログインする
        click_link "ログイン"
        fill_in_login_form(user)
        click_button "ログイン"
        expect(page).to have_content "メールアドレスの本人確認が必要です。"
        expect(page).to_not have_selector(".dropdown-toggle", text: "アカウント")
      end
    end

    context "本人確認を行った場合" do
      example "ログインできること" do
        click_link "ログイン"
        click_link "アカウントの新規登録はこちら"

        # アカウントを新規登録する
        user = build(:user, confirmed_at: nil)
        fill_in_signup_form(user)
        expect { click_button "アカウントを作成" }.to \
          change { ActionMailer::Base.deliveries.size }.by(1).and \
          change { User.all.size }.by(1)
        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).to have_content "本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。"

        # 本人確認する
        mail = ActionMailer::Base.deliveries.last
        url = extract_url(mail)
        visit url
        expect(page).to have_content "メールアドレスが確認できました。"
        expect(page).to have_current_path new_user_session_path, ignore_query: true

        # ログインする
        click_link "ログイン"
        fill_in_login_form(user)
        click_button "ログイン"
        expect(page).to have_content "ログインしました。"
        expect(page).to have_selector(".dropdown-toggle", text: "アカウント")
      end
    end
  end

  context "新規登録フォームへの入力値が無効な場合" do
    context "メールアドレスが未入力の場合" do
      example "アカウントが登録されないこと" do
        click_link "ログイン"
        click_link "アカウントの新規登録はこちら"

        # アカウントを新規登録する
        user = build(:user, email: "", confirmed_at: nil)
        fill_in_signup_form(user)
        expect { click_button "アカウントを作成" }.to \
          change { ActionMailer::Base.deliveries.size }.by(0).and \
          change { User.all.size }.by(0)
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content "メールアドレスを入力してください"
      end
    end

    context "パスワードが未入力の場合" do
      example "アカウントが登録されないこと" do
        click_link "ログイン"
        click_link "アカウントの新規登録はこちら"

        # アカウントを新規登録する
        user = build(:user, password: "", confirmed_at: nil)
        fill_in_signup_form(user)
        expect { click_button "アカウントを作成" }.to \
          change { ActionMailer::Base.deliveries.size }.by(0).and \
          change { User.all.size }.by(0)
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content "パスワードを入力してください"
      end
    end

    context "パスワード確認が未入力の場合" do
      example "アカウントが登録されないこと" do
        click_link "ログイン"
        click_link "アカウントの新規登録はこちら"

        # アカウントを新規登録する
        user = build(:user, password_confirmation: "", confirmed_at: nil)
        fill_in_signup_form(user)
        expect { click_button "アカウントを作成" }.to \
          change { ActionMailer::Base.deliveries.size }.by(0).and \
          change { User.all.size }.by(0)
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content "パスワード（確認用）とパスワードの入力が一致しません"
      end
    end

    context "パスワードが不一致の場合" do
      example "アカウントが登録されないこと" do
        click_link "ログイン"
        click_link "アカウントの新規登録はこちら"

        # アカウントを新規登録する
        user = build(:user, password: "password", password_confirmation: "123456", confirmed_at: nil)
        fill_in_signup_form(user)
        expect { click_button "アカウントを作成" }.to \
          change { ActionMailer::Base.deliveries.size }.by(0).and \
          change { User.all.size }.by(0)
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content "パスワード（確認用）とパスワードの入力が一致しません"
      end
    end

    context "パスワードが6文字より短い場合" do
      example "アカウントが登録されないこと" do
        click_link "ログイン"
        click_link "アカウントの新規登録はこちら"

        # アカウントを新規登録する
        user = build(:user, password: "pass", password_confirmation: "pass", confirmed_at: nil)
        fill_in_signup_form(user)
        expect { click_button "アカウントを作成" }.to \
          change { ActionMailer::Base.deliveries.size }.by(0).and \
          change { User.all.size }.by(0)
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content "パスワードは6文字以上で入力してください"
      end
    end
  end
end
