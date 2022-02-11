require "rails_helper"

RSpec.describe "Registrations", type: :system do
  describe "レイアウト確認" do
    example "新規登録画面の要素が正しく表示されること" do
      visit new_user_registration_path
      expect(page).to have_current_path new_user_registration_path

      expect(page).to have_selector "h1", text: "新規登録"
      expect(page).to have_selector "label[for=user_email]", text: "メールアドレス"
      expect(page).to have_selector "input#user_email"
      expect(page).to have_selector "label[for=user_password]", text: "パスワード"
      expect(page).to have_selector "input#user_password"
      expect(page).to have_selector "label[for=user_password_confirmation]", text: "パスワード（確認用）"
      expect(page).to have_selector "input#user_password_confirmation"
      expect(page).to have_button "アカウントを作成"
    end
  end

  describe "新規登録機能" do
    before do
      ActionMailer::Base.deliveries.clear
      visit root_path
      click_link "ログイン"
      click_link "アカウントの新規登録はこちら"
    end

    context "新規登録フォームへの入力値が有効な場合" do
      example "新規登録されること" do
        user = build(:user, confirmed_at: nil)
        fill_in_signup_form(user)
        expect { click_button "アカウントを作成" }.to \
          change { ActionMailer::Base.deliveries.size }.by(1).and \
            change { User.count }.by(1)

        expect(page).to have_current_path root_path
        expect(page).to have_content "本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。"
      end
    end

    context "新規登録フォームへの入力値が無効な場合" do
      context "メールアドレスが未入力の場合" do
        example "新規登録されないこと" do
          user = build(:user, email: "", confirmed_at: nil)
          fill_in_signup_form(user)
          expect { click_button "アカウントを作成" }.to \
            change { ActionMailer::Base.deliveries.size }.by(0).and \
              change { User.count }.by(0)

          expect(page).to have_current_path users_path
          expect(page).to have_content "メールアドレスを入力してください"
        end
      end

      context "パスワードが未入力の場合" do
        example "新規登録されないこと" do
          user = build(:user, password: "", confirmed_at: nil)
          fill_in_signup_form(user)
          expect { click_button "アカウントを作成" }.to \
            change { ActionMailer::Base.deliveries.size }.by(0).and \
              change { User.count }.by(0)

          expect(page).to have_current_path users_path
          expect(page).to have_content "パスワードを入力してください"
        end
      end

      context "パスワード確認が未入力の場合" do
        example "新規登録されないこと" do
          user = build(:user, password_confirmation: "", confirmed_at: nil)
          fill_in_signup_form(user)
          expect { click_button "アカウントを作成" }.to \
            change { ActionMailer::Base.deliveries.size }.by(0).and \
              change { User.count }.by(0)

          expect(page).to have_current_path users_path
          expect(page).to have_content "パスワード（確認用）とパスワードの入力が一致しません"
        end
      end

      context "パスワードが不一致の場合" do
        example "新規登録されないこと" do
          user = build(:user, password: "password", password_confirmation: "123456", confirmed_at: nil)
          fill_in_signup_form(user)
          expect { click_button "アカウントを作成" }.to \
            change { ActionMailer::Base.deliveries.size }.by(0).and \
              change { User.count }.by(0)

          expect(page).to have_current_path users_path
          expect(page).to have_content "パスワード（確認用）とパスワードの入力が一致しません"
        end
      end

      context "パスワードが6文字より短い場合" do
        example "新規登録されないこと" do
          user = build(:user, password: "pass", password_confirmation: "pass", confirmed_at: nil)
          fill_in_signup_form(user)
          expect { click_button "アカウントを作成" }.to \
            change { ActionMailer::Base.deliveries.size }.by(0).and \
              change { User.count }.by(0)

          expect(page).to have_current_path users_path
          expect(page).to have_content "パスワードは6文字以上で入力してください"
        end
      end
    end
  end

  describe "本人確認機能" do
    before do
      ActionMailer::Base.deliveries.clear
    end

    example "本人確認機能が正しく機能していること" do
      visit root_path
      click_link "ログイン"
      click_link "アカウントの新規登録はこちら"

      # アカウントを新規登録する
      user = build(:user, confirmed_at: nil)
      fill_in_signup_form(user)
      expect { click_button "アカウントを作成" }.to \
        change { ActionMailer::Base.deliveries.size }.by(1).and \
          change { User.count }.by(1)

      expect(page).to have_current_path root_path
      expect(page).to have_content "本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。"

      # ログインできないことを確認する
      click_link "ログイン"
      fill_in_login_form(user)
      click_button "ログイン"

      expect(page).to have_content "メールアドレスの本人確認が必要です。"
      expect(page).to have_no_selector(".dropdown-toggle", text: "アカウント")

      # 本人確認する
      mail = ActionMailer::Base.deliveries.last
      url = extract_url(mail)
      visit url
      expect(page).to have_content "メールアドレスが確認できました。"
      expect(page).to have_current_path new_user_session_path, ignore_query: true

      # ログインできることを確認する
      click_link "ログイン"
      fill_in_login_form(user)
      click_button "ログイン"

      expect(page).to have_content "ログインしました。"
      expect(page).to have_selector(".dropdown-toggle", text: "アカウント")
    end
  end
end
