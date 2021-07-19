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

  # post '/users/update
  # Requires JWT in header to authorise and direct update to user
  def update
    @user = current_user
    if @user.update(user_params)
      render json: generate_token(@user), status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end

  def generate_token(user)
    auth_token = Knock::AuthToken.new payload: { sub: user.id }
    { email: user.email, username: user.username, jwt: auth_token.token }
  end
end
