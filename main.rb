require "sinatra"
require "sinatra/reloader"
require "movies"
require "stock_quote"
require "image_suckr"
require "pry"
get "/" do
  @current_page = "/"
  erb :index
end

get "/movies" do
  @current_page = "movies"
  erb :movies
end

post "/movies_result" do
  @current_page = "movies"
  begin
    movie = Movies.find_by_title(params[:mov_name], {tomatoes: "true"})
    if movie.title.nil?
      @error = "This is not a valid movie"
      erb :movies
    else
      @mov_name = params[:mov_name]
      @title = movie.title
      @rating = movie.tomato.rating
      @director = movie.director
      @runtime = movie.runtime
      @year = movie.year
      suckr = ImageSuckr::GoogleSuckr.new 
      @poster = suckr.get_image_url({"q" => @mov_name + "movie"})
      erb :movies_result
    end
  rescue
    @error = "This is not a valid movie"
    erb :movies
  end
  
end

get "/stocks" do
  @current_page = "stocks"
  erb :stocks
end

post "/stocks_result" do
  @current_page = "stocks"
  begin
    @stock_name = params[:stock_name]
    @company = StockQuote::Stock.quote(@stock_name).company
    @exchange = StockQuote::Stock.quote(@stock_name).exchange
    @last = StockQuote::Stock.quote(@stock_name).last
    @high = StockQuote::Stock.quote(@stock_name).high
    @low = StockQuote::Stock.quote(@stock_name).low
    erb :stocks_result
  rescue
    @error_stock = "We could not find that stock quote, please try again."
    erb :stocks
  end
end

get "/images" do
  @current_page = "images"
  erb :images
end

get "/images_result" do
  @current_page = "images"
  begin
    @img_name = params[:img_name]
    suckr = ImageSuckr::GoogleSuckr.new 
    @photo = suckr.get_image_url({"q" => @img_name})
    @current_page = "images"
    erb :images_result
  rescue
    @error_images = "We could not find that image, please try again."
    erb :images
  end
end

post "/random_result" do
  @current_page = "images"
    params[:img_random]
    suckr = ImageSuckr::GoogleSuckr.new 
    arr = ["car", "dog", "cat", "lake", "jump", "hurdle", "skyscraper", "luge", "tree", "scatter", "artist", "paint"] 
    @img_random = arr.sample
    @rand_photo = suckr.get_image_url({"q" => @img_random})
    erb :random_result
end



