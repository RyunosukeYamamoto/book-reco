class UsersController < ApplicationController
  before_action :require_user_logged_in, except: [:new, :create]
  before_action :set_user, only: [:show, :followings, :followers, :will_read, :read]
  
  def index
    if params[:search].present?
      @users = User.where(name: params[:search]).order(id: :desc).page(params[:page]).per(15)
    else
      @users = User.order(id: :desc).page(params[:page]).per(15)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "ユーザを登録しました。"
      session[:user_id] = @user.id
      redirect_to @user
    else
      flash.now[:danger] = "ユーザの登録に失敗しました。"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if current_user.update(user_params)
      flash[:success] = 'ユーザ情報が編集されました'
      redirect_to current_user
    else
      flash[:danger] = 'ユーザー情報は編集されませんでした'
      redirect_to edit_user_url(current_user)
    end
  end
  
  def destroy
    if current_user == User.find(params[:id])
      current_user.destroy
      flash[:success] = '退会しました。'
    end
    redirect_to root_url
  end
  
  def show
    @books = @user.books.where(status: ['読書中', nil]).order(id: :desc).page(params[:page]).per(15)
    this_month_books(@user)
  end
  
  def will_read
    @books = @user.books.where(status: '読みたい').order(id: :desc).page(params[:page]).per(15)
    this_month_books(@user)
  end
  
  def read
    @books = @user.books.where(status: '読了').order(id: :desc).page(params[:page]).per(15)
    this_month_books(@user)
  end
  
  def followings
    @followings = @user.followings.page(params[:page]).per(15)
  end
  
  def followers
    @followers = @user.followers.page(params[:page]).per(15)
  end
  
  def ranking
    rank_hash = {}
    User.all.each do |user|
      this_month_books(user)
      rank_hash[user] = @this_month_books.count
    end
    @rank_hash = rank_hash.sort_by { |_, v| -v }.to_h
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
    counts(@user)
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def this_month_books(user)
    first_of_month = Date.today.beginning_of_month
    end_of_month = Date.today.end_of_month
    @this_month = Date.today.month
    
    @this_month_books = user.books.where(date: first_of_month..end_of_month).order(id: :desc).page(params[:page]).per(15)
  end
end