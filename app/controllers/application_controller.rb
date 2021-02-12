class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def require_user_logged_in
    redirect_to login_url unless logged_in?
  end

  def counts(user)
    @count_books = user.books.count
    @count_will_read = user.books.where(status: '読みたい').count
    @count_reading = user.books.where(status: ['読書中', nil]).count
    @count_read = user.books.where(status: '読了').count
    @count_followings = user.followings.count
    @count_followers = user.followers.count
  end
  
  def this_month_books(user)
    first_of_month = Date.today.beginning_of_month
    end_of_month = Date.today.end_of_month
    @this_month = Date.today.month

    @this_month_books = user.books.where(date: first_of_month..end_of_month).order(id: :desc).page(params[:page]).per(15)
  end
end
