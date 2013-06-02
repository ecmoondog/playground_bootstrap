require "sinatra"
require "sinatra/reloader"
require "movies"
require "stock_quote"
require "image_suckr"

get "/" do
  erb :index
end

get "/movies" do
  erb :movies
end

get "/movies_result" do

  @mov_name = params[:mov_name]
  @title = Movies.find_by_title(@mov_name).title
  @rating = Movies.find_by_title(@mov_name).rating
  @director = Movies.find_by_title(@mov_name).director
  @runtime = Movies.find_by_title(@mov_name).runtime
  @year = Movies.find_by_title(@mov_name).year
  suckr = ImageSuckr::GoogleSuckr.new 
  @poster = suckr.get_image_url({"q" => @mov_name})


  erb :movies_result
end

get "/stocks" do
  erb :stocks
end

get "/stocks_result" do
  begin
    @stock_name = params[:stock_name]
    @company = StockQuote::Stock.quote(@stock_name).company
    @exchange = StockQuote::Stock.quote(@stock_name).exchange
    @last = StockQuote::Stock.quote(@stock_name).last
    @high = StockQuote::Stock.quote(@stock_name).high
    @low = StockQuote::Stock.quote(@stock_name).low
  rescue
    "We could not find that stock quote, please try again."
  end

  erb :stocks_result
end

get "/images" do
  erb :images
end

get "/images_result" do
  if 
    @img_name = params[:img_name]
    suckr = ImageSuckr::GoogleSuckr.new 
    @photo = suckr.get_image_url({"q" => @img_name})
  else
    suckr = ImageSuckr::GoogleSuckr.new
    @photo = suckr.get_image_url
  end

  erb :images_result
end


