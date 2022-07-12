class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to user_url(@user)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def show
  end



  private

  def user_params
    # debugger
    params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
  end
end
