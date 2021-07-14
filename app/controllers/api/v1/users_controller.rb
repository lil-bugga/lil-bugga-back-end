class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false
  before_action :authenticate_user, except: [:signup,:signin]

  # GET /users
  # Will be used for user authorization, index method may not be required
  def signup
    @user = User.new(user_params)
    @user.email.downcase!
    if @user.save
      render json: generate_token(@user), status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def signin
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user && @user.authenticate(params[:user][:password])
      render json: generate_token(@user), status: 200
    else
      render status: :unauthorized,
             json: @user.nil? ? { error: 'user not found' } : { error: 'invalid password' }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def generate_token(user)
    auth_token = Knock::AuthToken.new payload: { sub: user.id }
    { username: user.email, jwt: auth_token.token }
  end
end
