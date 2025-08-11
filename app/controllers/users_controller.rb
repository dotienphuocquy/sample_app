class UsersController < ApplicationController
  before_action :load_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.all
  end

  def show; end

  def destroy
    if @user.destroy
      flash[:success] = t("delete_successed")
    else
      flash[:danger] = t("delete_failed!")
    end
    redirect_to users_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t("check_activate_email")
      redirect_to root_url, status: :see_other
    else
      flash[:error] = t("sign_up_failed")
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t("profile_updated")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("user_not_found")
    redirect_to root_url
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("please_log_in")
    redirect_to login_url
  end

  def correct_user
    return if current_user?(@user)

    flash[:error] = t("cannot_edit")
    redirect_to root_url
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def user_params
    params.require(:user).permit User::USER_PERMIT
  end
end
