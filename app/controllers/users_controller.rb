class UsersController < ApplicationController
  def show
    redirect_to_root_with_error("User not found") unless
      @user = User.find_by_name(User.unescape(params[:id]), :include => [ :books ])
  end
end
