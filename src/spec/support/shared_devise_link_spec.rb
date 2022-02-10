shared_examples "ログイン画面に遷移できること" do
  example do
    click_link "ログインはこちら"
    expect(page).to have_current_path new_user_session_path
  end
end

shared_examples "新規登録画面に遷移できること" do
  example do
    click_link "アカウントの新規登録はこちら"
    expect(page).to have_current_path new_user_registration_path
  end
end

shared_examples "認証メール再送画面に遷移できること" do
  example do
    click_link "認証メールが届かなかった場合はこちら"
    expect(page).to have_current_path new_user_confirmation_path
  end
end

shared_examples "パスワード再設定画面（メール送信用）に遷移できること" do
  example do
    click_link "パスワードを忘れた方はこちら"
    expect(page).to have_current_path new_user_password_path
  end
end
