class CommentsController < ApplicationController
  before_action :correct_user, only: [:destroy]
  
  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = 'リプライしました'
      redirect_back(fallback_location: root_path)
    else
      flash.now[:danger] = 'リプライできませんでした'
      @user = @comment.user
      @books = @user.books.order(id: :desc).page(params[:page]).per(6)
      counts(@user)
      render 'users/show'
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = "コメントを削除しました"
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:book_id, :content)
  end
  
  def correct_user
    @comment = current_user.comments.find_by(id: params[:id])
    unless @comment
      redirect_to root_url
    end
  end
end