class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def authenticate!
     flash[:alert] = '必須登入才能張貼工作資訊喔'
     redirect_to root_path unless user_signed_in?
  end

  def user_signed_in?
     !!session[:user_id]
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
