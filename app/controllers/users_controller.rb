class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :show, :update]
  before_action :correct_user,   only: [:edit, :show, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.process_resume
      @user.process_school
      @user.process_major
      log_in @user
      flash[:success] = "Welcome"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end

private

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless (current_user?(@user) || current_user.is_admin)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password,
                                 :password_confirmation, :resume, :phone_number,
                                 :sex, :school, :major, :year, :first_hackathon,
                                 :hardware, :what_are_you_building, :what_have_you_build,
                                 :github_username, :linkedin_url, :personal_website,
                                 :dietary_restrictions, :size, :additional_info)
  end

end
