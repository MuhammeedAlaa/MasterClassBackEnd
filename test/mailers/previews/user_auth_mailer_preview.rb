# Preview all emails at http://localhost:3000/rails/mailers/user_auth_mailer
class UserAuthMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_auth_mailer/reset
  def reset
    UserAuthMailer.reset
  end

end
