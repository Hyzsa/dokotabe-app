module LogInModule
  # (user)でログインする。
  def log_in_as(user)
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
  end

  # ゲストユーザーでログインする。
  def log_in_as_guest
    visit new_user_session_path
    click_link "ゲストログイン", href: users_guest_sign_in_path
  end

  # ログインフォームに(user)のログイン情報を入力する。
  def fill_in_login_form(user)
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
  end
end
