class BooksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :code_present, only: [:book]
  
  def new
    @book = current_user.books.build
  end
  
  def create
    @book = current_user.books.build(book_params)
    
    if @book.save
      flash[:success] = '本棚に追加!'
      redirect_to current_user
    else
      @books = current_user.feed_books.order(id: :desc).page(params[:page]).per(15)
      flash.now[:danger] = '本の追加に失敗しました'
      render 'toppages/index'
    end
  end
  
  def show
    @book = Book.find(params[:id])
    @comment = current_user.comments.build #form_with用
    if @book.page.present? && @book.nowpage.present?
      @progress = (@book.nowpage*100) / @book.page
    end
  end
  
  def edit
  end
  
  def update
    if @book.update(book_params)
      flash[:success] = '読書記録が編集されました'
      redirect_to @book
    else
      flash.now[:danger] = '読書記録は編集されませんでした'
      render :edit
    end
  end
  
  def destroy
    @book.destroy
    flash[:success] = '本を削除しました'
    redirect_to current_user
  end
  
  def book
    @books_by_code = Book.where(code: @book.code)
    @for_submit = current_user.books.build
  end
  
  private
  
  def book_params
    params.require(:book).permit(:title, :impression, :page, :nowpage, :status, :code, :img, :date)
  end
  
  def correct_user
    @book = current_user.books.find_by(id: params[:id])
    unless @book
      redirect_to root_url
    end
  end
  
  def code_present
    @book = Book.find(params[:id])
    unless @book.code
      redirect_to root_url
    end
  end
end