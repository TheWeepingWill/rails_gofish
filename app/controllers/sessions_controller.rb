class SessionsController < ApplicationController
  def new 
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      reset_session
      log_in @user
      redirect_to games_url
    else
      @user = User.new
      flash.now[:danger] = 'Incorrect User or Password'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end

end