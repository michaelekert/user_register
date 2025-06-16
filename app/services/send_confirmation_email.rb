class SendConfirmationEmail
  include Dry::Monads[:result, :do, :try]

  def call(user, token)
    Try {
      UserMailer.confirmation_email(user, token).deliver_now
    }.to_result.bind do
      Success(user)
    end.or do |error|
      Failure(:email_delivery_failed)
    end
  end
end