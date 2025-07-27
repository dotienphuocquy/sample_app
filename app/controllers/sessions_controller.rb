class SessionsController < ApplicationController
  def new; end

  # signup
  def create
    user = User.find_by(email: params.dig(:session, :email)&.downcase)

    if user.try(:authenticate, params.dig(:session, :password))
      log_in_and_redirect user
    else
      flash.now[:danger] = t "invalid_email_password_combination"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end
end
