module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def logged_in?
    current_user.present?
  end

  def current_user? user
    user == current_user
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def log_out
    forget current_user
    reset_session
    @current_user = nil
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by id: user_id
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by id: user_id
      if user&.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def log_in_and_redirect user
    reset_session
    log_in user

    handle_remember_me(user)

    forwarding_url = session[:forwarding_url]
    redirect_to forwarding_url || user
  end

  def handle_remember_me user
    if params.dig(:session, :remember_me) == "1"
      remember(user)
    else
      forget(user)
    end
  end
end
