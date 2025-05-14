# app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  def index
    api_key = ENV["API_KEY"]
    auth_token = ENV["TOKEN"]

    api_url = "https://api.themoviedb.org/3/movie/popular?api_key=#{api_key}&language=es-MX&page=1"

    response = HTTParty.get(api_url, headers: { "Authorization" => "Bearer #{auth_token}" })

    if response.success?
      @movies = response.parsed_response["results"]
    else
      @movies = []
    end
  end

  def search
    query = params[:query]
    return @movies = [] if query.blank?
    api_key = ENV["API_KEY"]
    auth_token = ENV["TOKEN"]

    api_url = "https://api.themoviedb.org/3/search/movie?api_key=#{api_key}&lang=&query=#{query}&language=es-MX"

    response = HTTParty.get(api_url, headers: { "Authorization" => "Bearer #{auth_token}" })

    if response.success?
      @movies = response.parsed_response["results"]
    else
      @movies = []
    end
  end
end
