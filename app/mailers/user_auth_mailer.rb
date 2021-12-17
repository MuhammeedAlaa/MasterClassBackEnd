class UserAuthMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_auth_mailer.reset.subject
  #
  def reset
    @user = params[:user]
    @token = @user.signed_id(expires_in: 15.minutes, purpose: 'password_reset' )
    mail to: @user.email, from: 'donotreply@example.com', subject: '[Learnning Management System Reset Password]' 
  end
end
