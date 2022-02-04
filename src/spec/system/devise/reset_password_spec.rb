require "rails_helper"

RSpec.describe "Reset Password", type: :system do
  before do
    ActionMailer::Base.deliveries.clear
    visit root_path
    expect(page).to have_http_status(:success)
  end

  def extract_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end

  context "パスワード再設定トークンが正しい場合" do
    example "パスワードを変更できること" do
      user = create(:user)

      click_link "ログイン"

      # パスワード変更メールを送信する
      click_link "パスワードを忘れた方はこちら"
      fill_in "メールアドレス", with: user.email
      expect { click_button "再設定用メールを送信する" }.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(page).to have_content "パスワードの再設定について数分以内にメールでご連絡いたします。"

      # パスワードを変更する
      mail = ActionMailer::Base.deliveries.last
      url = extract_url(mail)
      visit url
      expect(page).to have_current_path edit_user_password_path, ignore_query: true

      new_password = "123456"
      fill_in "新しいパスワード", with: new_password
      fill_in "新しいパスワード（確認用）", with: new_password
      click_button "パスワードを変更"
      expect(page).to have_content "パスワードが正しく変更されました。"
      expect(page).to have_current_path root_path, ignore_query: true

      # ログイン済みになっているため、ログアウトする
      click_link "ログアウト"
      expect(page).to have_content "ログアウトしました。"

      # 変更前のパスワードでログインに失敗する
      click_link "ログイン"
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
      expect(page).to have_content "メールアドレスまたはパスワードが違います。"

      # 変更後のパスワードでログインに成功する
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: new_password
      click_button "ログイン"
      expect(page).to have_content "ログインしました。"
    end
  end

  context "パスワード再設定トークンが間違っている場合" do
    example "パスワードを変更できないこと" do
      user = create(:user)

      click_link "ログイン"

      # パスワード変更メールを送信する
      click_link "パスワードを忘れた方はこちら"
      fill_in "メールアドレス", with: user.email
      expect { click_button "再設定用メールを送信する" }.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(page).to have_content "パスワードの再設定について数分以内にメールでご連絡いたします。"

      # 適当なトークンをクエリで渡してパスワード変更画面にアクセスする
      visit edit_user_password_url(reset_password_token: Devise.friendly_token(10))
      expect(page).to have_current_path edit_user_password_path, ignore_query: true

      # パスワードを変更する
      new_password = "123456"
      fill_in "新しいパスワード", with: new_password
      fill_in "新しいパスワード（確認用）", with: new_password
      click_button "パスワードを変更"
      expect(page).to have_content "パスワードリセット用トークンは不正な値です"

      # 変更後のパスワードでログインに失敗する
      click_link "ログイン"
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: new_password
      click_button "ログイン"
      expect(page).to have_content "メールアドレスまたはパスワードが違います。"
    end
  end

  context "パスワード再設定トークンがない場合" do
    example "パスワードを変更できないこと" do
      user = create(:user)

      click_link "ログイン"

      # パスワード変更メールを送信する
      click_link "パスワードを忘れた方はこちら"
      fill_in "メールアドレス", with: user.email
      expect { click_button "再設定用メールを送信する" }.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(page).to have_content "パスワードの再設定について数分以内にメールでご連絡いたします。"

      # クエリなしでパスワード変更画面にアクセスする
      visit edit_user_password_url
      expect(page).to_not have_current_path edit_user_password_path, ignore_query: true
      expect(page).to have_content "このページにはアクセスできません。パスワード再設定メールのリンクからアクセスされた場合には、URL をご確認ください。"
    end
  end
end
