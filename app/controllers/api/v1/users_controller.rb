class Api::V1::UsersController < ApplicationController
  # before_action :set_user, only: %i[show update destroy]
  # before_action :set_user, only: %i[signin]

  # GET /users
  # Will be used for user authorization, index method may not be required
  def signup
    @user = User.new(user_params)
    @user.email.downcase!

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def signin
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user && @user.authenticate(params[:user][:password])
      render json: @user, status: 200
    else
      render status: :unprocessable_entity, json: @user.nil? ? { error: "user not found"} : {error: "invalid password"}
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
