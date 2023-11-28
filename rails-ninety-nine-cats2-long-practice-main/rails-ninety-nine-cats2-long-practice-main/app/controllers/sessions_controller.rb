class SessionsController < ApplicationController

  def new
    @user = User.new
    render :new
  end

  def create
    username = params[:user][:username]
    password = params[:user][:password]

    @user = User.find_by_credentials(username, password)

    if @user
      login(@user)
      redirect_to cats_url
    else
      render :new
    end
  end

  def destroy
    current_user.reset_session_token! if current_user
  end
end
