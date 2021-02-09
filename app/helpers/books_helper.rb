module BooksHelper
  def in_bookshelf?(code)
    @one_book = current_user.books.where(code: code)
    if @one_book.present?
      true
    else
      false
    end
  end
end