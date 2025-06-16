class UserMailer < ApplicationMailer
    default from: 'no-reply@twojadomena.pl'

  def confirmation_email(user, token)
    @user = user
    @token = token
    @confirmation_url = confirm_users_url(token: @token)

    mail(to: @user.email, subject: 'Potwierdź swoje konto')
  end
end
