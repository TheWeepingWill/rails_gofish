class SessionsController < ApplicationController
  def new 
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      reset_session
      log_in @user
      redirect_to @user
    else
      @user = User.new
      flash.now[:danger] = 'Incorrect User or Password'
      render 'new', status: :unprocessable_entity
    end
  end
end