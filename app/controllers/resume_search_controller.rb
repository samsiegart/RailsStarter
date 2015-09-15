class ResumeSearchController < ApplicationController
  before_action :is_admin_or_sponsor

  def search
    if params[:q].nil?
      @users = []
    else
      @users = User.search(params[:q]).map {|user| user._source}
    end
  end

private
  def is_admin_or_sponsor
    if logged_in?
      unless current_user.is_admin || !current_user.sponsorship.blank?
        redirect_to root_url
      end
    else
      store_location
      flash[:danger] = "You need to be logged in as a Sponsor to view resumes"
      redirect_to login_url
    end
  end
end
