module SignUpModule
  def fill_in_signup_form(new_user)
    fill_in "メールアドレス", with: new_user.email
    fill_in "パスワード", with: new_user.password
    fill_in "パスワード（確認用）", with: new_user.password_confirmation
  end

  def extract_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end
end
