class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  include Dry::Monads[:result, :do]

  def create
    result = create_user(user_params)

    if result.success?
      render json: { message: "Zarejestrowano użytkownika. Sprawdź e-mail aby potwierdzić konto." }, status: :created
    else
      render json: { errors: result.failure }, status: :unprocessable_entity
    end
  end

  def confirm
    token = params[:token]
    result = ConfirmUserService.new.call(token)

    case result
    when Success
      flash[:notice] = "Konto zostało potwierdzone."
    when Failure
      flash[:alert] = result.failure
    end
  end

  private

  def create_user(params)
    user = yield RegisterUserService.new.call(params)
    token = yield GenerateConfirmationTokenService.new.call(user)
    yield SendConfirmationEmail.new.call(user, token)
    Success()
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
