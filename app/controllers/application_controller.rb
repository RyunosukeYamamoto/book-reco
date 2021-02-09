class ApplicationController < ActionController::Base
  
  include SessionsHelper
  
  private
  
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def counts(user)
    @count_books = user.books.count
    @count_will_read = user.books.where(status: '読みたい').count
    @count_reading = user.books.where(status: ['読書中', nil]).count
    @count_read = user.books.where(status: '読了').count
    @count_followings = user.followings.count
    @count_followers = user.followers.count
  end
end
