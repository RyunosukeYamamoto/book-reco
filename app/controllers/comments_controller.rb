class CommentsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    @book = Book.find(comment_params[:book_id])
    if @comment.save
      flash[:success] = 'リプライしました'
      redirect_to book_url(@book)
    else
      flash.now[:danger] = 'リプライできませんでした'
      @progress = (@book.nowpage * 100) / @book.page if @book.page.present? && @book.nowpage.present?
      render 'books/show'
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = 'コメントを削除しました'
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:comment).permit(:book_id, :content)
  end

  def correct_user
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to root_url unless @comment
  end
end
