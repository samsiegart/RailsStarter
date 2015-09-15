class AdminController < ApplicationController
  before_action :user_is_admin

  def index
    @users = User.all
  end

private

  def user_is_admin
    if logged_in?
      unless current_user.is_admin
        redirect_to root_url
      end
    else
      store_location
      flash[:danger] = "Please log in to continue"
      redirect_to login_url
    end
  end
end
