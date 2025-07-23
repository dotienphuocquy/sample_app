class UsersController < ApplicationController
  before_action :load_user, only: [:show]

  def show
    return if @user

    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t("user_created_successful")
      redirect_to @user, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit User::USER_PERMIT
  end

  def load_user
    @user = User.find_by id: params[:id]
  end
end
