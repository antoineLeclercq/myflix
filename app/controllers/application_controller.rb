class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def redirect_logged_in_user
    redirect_to home_path if logged_in?
  end

  def require_user
    redirect_to root_path unless logged_in?
  end
end
