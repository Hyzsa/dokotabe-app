module LogInModule
  def log_in_as(user)
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
  end

  def fill_in_login_form(user)
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
  end
end
