require 'dry/monads'
class ConfirmUserService
  include Dry::Monads[:result, :try, :do]
  SECRET = "aaa"
  
  def call(token)
    payload = yield decode_token(token)
    user = User.find_by(id: payload['user_id'])
    return Failure(:user_not_found) unless user
    return Failure(:already_confirmed) if user.confirmed_at.present?

    if user.update(confirmed_at: Time.current)
      Success(user)
    else
      Failure(user.errors.full_messages)
    end
  end

  private

  def decode_token(token)
    puts "Received token: #{token}"
    Try {
      JWT.decode(token, SECRET, algorithm: 'HS256').first
    }.to_result.or(Failure(:invalid_token))
  end
end