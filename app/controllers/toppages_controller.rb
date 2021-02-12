class ToppagesController < ApplicationController
  def index
    if logged_in?
      @books = current_user.feed_books.order(id: :desc).page(params[:page]).per(15)
      counts(current_user)
      this_month_books(current_user)
    else
      @user = User.new
    end
  end
end
