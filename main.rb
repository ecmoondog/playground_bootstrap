require "sinatra"
require "sinatra/reloader"
require "movies"
require "stock_quote"
require "image_suckr"

get "/" do
  @current_page = "/"
  erb :index
end

get "/movies" do
  @current_page = "movies"
  erb :movies
end

post "/movies_result" do
  begin
    movie = Movies.find_by_title(params[:mov_name])
    if
      movie.title.nil?
      puts "This is not a valid movie"
      @current_page = "movies"
      erb :movies
    else
      @mov_name = params[:mov_name]
      @title = Movies.find_by_title(@mov_name).title
      @rating = Movies.find_by_title(@mov_name).rating #this is not yet working...
      @director = Movies.find_by_title(@mov_name).director
      @runtime = Movies.find_by_title(@mov_name).runtime
      @year = Movies.find_by_title(@mov_name).year
      suckr = ImageSuckr::GoogleSuckr.new 
      @poster = suckr.get_image_url({"q" => @mov_name + "movie"})
    end
  end
  @current_page = "movies"
  erb :movies_result
end

get "/stocks" do
  @current_page = "stocks"
  erb :stocks
end

post "/stocks_result" do
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
  @current_page = "stocks"
  erb :stocks_result
end

get "/images" do
  @current_page = "images"
  erb :images
end

get "/images_result" do
    @img_name = params[:img_name]
    suckr = ImageSuckr::GoogleSuckr.new 
    @photo = suckr.get_image_url({"q" => @img_name})
    @current_page = "images"
    erb :images_result
end

post "/random_result" do
    params[:img_random]
    suckr = ImageSuckr::GoogleSuckr.new 
    arr = ["car", "dog", "cat", "lake", "jump", "hurdle", "skyscraper", "luge", "tree", "scatter", "artist", "paint"] 
    @img_random = arr.sample
    @rand_photo = suckr.get_image_url({"q" => @img_random})
    erb :random_result
end



