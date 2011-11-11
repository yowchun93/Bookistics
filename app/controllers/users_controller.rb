class UsersController < ApplicationController

  USER_PROFILE_TABS = {
    :reading    => "Reading",
    :read       => "Read",
    :to_read    => "Wants to read",
    :statistics => "Statistics"
  }


  def index
    @users = User
               .paginate(:page => params[:page])
               .order("created_at DESC")
  end

  def show
    if User.param_exists? params[:id]
      @tab = params[:tab].to_sym || :reading

      @tab = :reading unless USER_PROFILE_TABS.keys.include? @tab

      @user = User.from_param(params[:id])

      @books = case @tab
                 when :reading then Book.user_reading_books(@user)
                 when :read    then Book.user_read_books(@user)
                 when :to_read then Book.user_wants_to_read_books(@user)
                 else []
               end
    else
      redirect_to_root_with_error("User not found")
    end
  end
end
