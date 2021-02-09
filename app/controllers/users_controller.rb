class UsersController < ApplicationController
  def index
    if params[:search].present?
      @users = User.where(name: params[:search]).order(id: :desc).page(params[:page]).per(15)
    else
      @users = User.order(id: :desc).page(params[:page]).per(15)
    end
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books.where(status: ['読書中', nil]).order(id: :desc).page(params[:page]).per(15)
    counts(@user)
    this_week_books(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "ユーザを登録しました。"
      redirect_to login_url
    else
      flash.now[:danger] = "ユーザの登録に失敗しました。"
      render :new
    end
  end
  
  def destroy
    if current_user == User.find(params[:id])
      current_user.destroy
      flash[:success] = '退会しました。'
    end
    redirect_to root_url
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page]).per(15)
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page]).per(15)
    counts(@user)
  end
  
  def will_read
    @user = User.find(params[:id])
    @books = @user.books.where(status: '読みたい').order(id: :desc).page(params[:page]).per(15)
    counts(@user)
    this_week_books(@user)
  end
  
  def read
    @user = User.find(params[:id])
    @books = @user.books.where(status: '読了').order(id: :desc).page(params[:page]).per(15)
    counts(@user)
    this_week_books(@user)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def this_week_books(user)
    this_day = Date.today
    @this_sunday = this_day - this_day.wday # 今週の日曜日
    @next_saturday = this_day - this_day.wday + 6 # 次の土曜日
    
    @this_week_books = user.books.where(date: @this_sunday..@next_saturday).order(id: :desc).page(params[:page]).per(15)
  end
end