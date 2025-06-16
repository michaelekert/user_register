require 'dry/monads'

class GenerateConfirmationTokenService
  include Dry::Monads[:result, :try]
  SECRET = "aaa"
  def call(user)
    Try {
      payload = {user_id: user.id, exp: 24.hours.from_now.to_i}
      JWT.encode(payload, SECRET, 'HS256')
  }.to_result.or(Failure("Error generating token"))
  end
end