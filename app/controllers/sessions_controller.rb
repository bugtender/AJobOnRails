class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    flash[:notice] = '歡迎光臨 Job on Rails !!'
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'Bye bye ~ Have a nice day !!'
    redirect_to root_url
  end
end
