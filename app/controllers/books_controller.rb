class BooksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :code_present, only: [:book]

  def create
    @book = current_user.books.build(book_params)

    if @book.save
      flash[:success] = '本棚に追加!'
      redirect_to current_user
    else
      flash.now[:danger] = '本の追加に失敗しました'
      render :search
    end
  end

  def show
    @book = Book.find(params[:id])
    @comment = current_user.comments.build # form_with用
    @progress = (@book.nowpage * 100) / @book.page if @book.page.present? && @book.nowpage.present?
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
  
  def new
    @book = current_user.books.build
  end
  
  def search
    @book = current_user.books.build
    @title = params[:title] if params[:title].present?
    @code = params[:code] if params[:code].present?
    @img = params[:img] if params[:img].present?

    if params[:keyword].present?
      require 'net/http'
      url = 'https://www.googleapis.com/books/v1/volumes?q='
      request = url + params[:keyword]
      enc_str = URI.encode(request)
      uri = URI.parse(enc_str)
      json = Net::HTTP.get(uri)
      @bookjson = JSON.parse(json)

      count = 9
      @books_api = Array.new(count).map { Array.new(3) }
      count.times do |x|
        @books_api[x][0] = @bookjson.dig('items', x, 'volumeInfo', 'title')
        @books_api[x][1] = @bookjson.dig('items', x, 'volumeInfo', 'imageLinks', 'thumbnail')
        @books_api[x][2] = @bookjson.dig('items', x, 'volumeInfo', 'industryIdentifiers', 0, 'identifier')
      end
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :impression, :page, :nowpage, :status, :code, :img, :date)
  end

  def correct_user
    @book = current_user.books.find_by(id: params[:id])
    redirect_to root_url unless @book
  end

  def code_present
    @book = Book.find(params[:id])
    redirect_to root_url unless @book.code
  end
end
