require 'dry/monads'

class RegisterUserService
  include Dry::Monads[:list, :result, :validated, :do]
  

  def call(form)
    name, email, password = yield List::Validated[
      validate_name(form),
      validate_email(form),
      validate_password(form)
    ].traverse.to_result
    
    user = User.new(name: name, email: email, password: password)

    if user.save
      Success(user)
    else
      Failure(user.errors.full_messages)
    end
  end

  private

  def validate_name(form)
    name = form[:name].to_s.strip
    return Invalid(:name_blank) if name.empty?
    Valid(name)
  end

  def validate_email(form)
    email = form[:email].to_s.strip
    return Invalid(:email_blank) if email.empty?
    return Invalid(:invalid_email_format) unless email.match?(/\A[^@\s]+@[^@\s]+\z/)
    Valid(email)
  end

  def validate_password(form)
    password = form[:password].to_s
    return Invalid(:password_too_short) if password.length < 6
    Valid(password)
  end
end