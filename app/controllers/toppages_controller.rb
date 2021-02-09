class ToppagesController < ApplicationController
  def index
    if logged_in?
      @book =current_user.books.build
      @books = current_user.feed_books.order(id: :desc).page(params[:page]).per(15)
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
        
        count = 5
        @books_api = Array.new(count).map{Array.new(3)}
        count.times do |x|
          @books_api[x][0] = @bookjson.dig("items", x, "volumeInfo","title")
          @books_api[x][1] = @bookjson.dig("items", x, "volumeInfo", "imageLinks", "thumbnail")
          @books_api[x][2] = @bookjson.dig("items", x, "volumeInfo", "industryIdentifiers", 0, "identifier")
        end
      end
    end
  end
end