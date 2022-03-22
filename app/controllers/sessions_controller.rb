class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email_or_username]) ||
           User.find_by(username: params[:email_or_username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user, success: "Welcome back, #{user.name}!"
    else
      flash.now[:danger] = 'Invalid username/password combination'
      render 'new'
    end
  end

  def destroy
  end
end
