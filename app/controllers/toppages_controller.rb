class ToppagesController < ApplicationController
  def index
    if logged_in?
      @books = current_user.feed_books.order(id: :desc).page(params[:page]).per(15)
      counts(current_user)
      this_month_books(current_user)
      last_month_books(current_user)
      last_last_month_books(current_user)
      @data_for_graph = { "#{@last_last_month}月(先々月)": @last_last_month_books.count, "#{@last_month}月(先月)": @last_month_books.count, "#{@this_month}月(今月)": @this_month_books.count }
    else
      @user = User.new
    end
  end
end
