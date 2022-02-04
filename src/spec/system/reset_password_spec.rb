require "rails_helper"

RSpec.describe "Reset Password", type: :system do
  before do
    ActionMailer::Base.deliveries.clear
  end

  def extract_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end

  example "ユーザー登録を行い、パスワードを変更する" do
    visit root_path
    expect(page).to have_http_status(:success)

    # アカウント新規登録
    click_link "ログイン"
    click_link "アカウントの新規登録はこちら"
    fill_in "メールアドレス", with: "foo@example.com"
    fill_in "パスワード", with: "123456"
    fill_in "パスワード（確認用）", with: "123456"
    expect { click_button "アカウントを作成" }.to change { ActionMailer::Base.deliveries.size }.by(1)
    expect(page).to have_content "本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。"

    # アカウントの有効化
    mail = ActionMailer::Base.deliveries.last
    url = extract_url(mail)
    visit url
    expect(page).to have_content "メールアドレスが確認できました。"
    expect(page).to have_current_path new_user_session_path, ignore_query: true

    # パスワード変更メールを送信する
    click_link "パスワードを忘れた方はこちら"
    fill_in "メールアドレス", with: "foo@example.com"
    expect { click_button "再設定用メールを送信する" }.to change { ActionMailer::Base.deliveries.size }.by(1)
    expect(page).to have_content "パスワードの再設定について数分以内にメールでご連絡いたします。"

    # パスワードを変更する
    mail = ActionMailer::Base.deliveries.last
    url = extract_url(mail)
    visit url
    expect(page).to have_current_path edit_user_password_path, ignore_query: true
    fill_in "新しいパスワード", with: "654321"
    fill_in "新しいパスワード（確認用）", with: "654321"
    click_button "パスワードを変更"
    expect(page).to have_content "パスワードが正しく変更されました。"
    expect(page).to have_current_path root_path, ignore_query: true

    # ログイン済みになっているため、ログアウトする
    click_link "ログアウト"
    expect(page).to have_content "ログアウトしました。"

    # 変更前のパスワードでログインに失敗する
    click_link "ログイン"
    fill_in "メールアドレス", with: "foo@example.com"
    fill_in "パスワード", with: "123456"
    click_button "ログイン"
    expect(page).to have_content "メールアドレスまたはパスワードが違います。"

    # 変更後のパスワードでログインに成功する
    fill_in "メールアドレス", with: "foo@example.com"
    fill_in "パスワード", with: "654321"
    click_button "ログイン"
    expect(page).to have_content "ログインしました。"
  end
end
