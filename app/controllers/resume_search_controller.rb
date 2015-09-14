class ResumeSearchController < ApplicationController
  def search
    if params[:q].nil?
      @users = []
    else
      @users = User.search(params[:q]).map {|user| user._source}
    end
  end
end
