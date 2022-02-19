# Preview all emails at http://localhost:3000/rails/mailers/devise_mailer
class DeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(User.new, Devise.friendly_token(10))
  end

  def email_changed
    user = User.new
    user.email = "after@example.com"
    user.unconfirmed_email = "before@example.com"
    Devise::Mailer.email_changed(user)
  end

  def password_change
    Devise::Mailer.password_change(User.new)
  end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.new, Devise.friendly_token(10))
  end

  # def unlock_instructions
  #   Devise::Mailer.unlock_instructions(User.new, Devise.friendly_token(10))
  # end
end
