class SessionsController < ApplicationController
  before_action :load_user, only: %i(create)
  def new; end

  # signup
  def create # rubocop:disable Metrics/AbcSize
    if @user&.authenticate(params[:session][:password])
      if @user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
        log_in @user
        redirect_to forwarding_url || @user
      else
        flash[:warning] = t("account_not_activated")
        redirect_to root_url, status: :see_other
      end
    else
      flash.now[:danger] = t("invalid_email_password_combination")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end

  private
  def load_user
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
    return if @user

    flash[:danger] = t("user_not_found")
    redirect_to root_url
  end
end
