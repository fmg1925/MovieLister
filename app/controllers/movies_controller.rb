# app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  def index
    api_key = ENV["API_KEY"]
    auth_token = ENV["TOKEN"]
    page = params[:page] || 1

    language = case I18n.locale
    when :es then "es-MX"
    when :en then "en-US"
    else "en-US"
    end

    api_url = "https://api.themoviedb.org/3/movie/popular?api_key=#{api_key}&language=#{language}&page=#{page}"

    response = HTTParty.get(api_url, headers: { "Authorization" => "Bearer #{auth_token}" })

    if response.success?
      @movies = response.parsed_response["results"]
      @movies.each do |movie|
        cached = get_cached_movie(movie["id"], language)

        if cached
          movie["title"] = cached.title
          movie["overview"] = cached.overview
          movie["poster_path"] = cached.poster_path
          movie["vote_average"] = cached.tmdb_vote_average
          movie["vote_count"] = cached.tmdb_vote_count
        else
          cache_movie_data(movie, language)
        end

        tmdb_rating_5 = movie["vote_average"].to_f / 2.0
        tmdb_votes = movie["vote_count"].to_i rescue 0

        user_ratings = Rating.where(movie_api_id: movie["id"])
        user_avg = user_ratings.average(:score) || 0
        user_count = user_ratings.count

        total_votes = tmdb_votes + user_count

        if total_votes > 0
          combined = ((tmdb_rating_5 * tmdb_votes) + (user_avg * user_count)) / total_votes
        else
          combined = tmdb_rating_5
        end

        movie["user_count"] = user_count
        movie["combined_rating"] = combined.round(2)
      end
      @total_pages = response.parsed_response["total_pages"]
      @current_page = page.to_i
    else
      @movies = []
      @total_pages = 1
      @current_page = 1
    end
  end

  def search
    query = params[:query]
    page = params[:page] || 1
    @current_page = page.to_i
    @total_pages = 0
    return @movies = [] if query.blank?
    api_key = ENV["API_KEY"]
    auth_token = ENV["TOKEN"]

    I18n.locale = params[:locale] || extract_locale_from_referer || :en
    language = case I18n.locale
    when :es then "es-MX"
    when :en then "en-US"
    else "en-US"
    end

    api_url = "https://api.themoviedb.org/3/search/movie?api_key=#{api_key}&query=#{query}&language=#{language}&page=#{page}"

    response = HTTParty.get(api_url, headers: { "Authorization" => "Bearer #{auth_token}" })

    if response.success?
       @movies = response.parsed_response["results"]
        @movies.each do |movie|
          cache_movie_data(movie, language)

          user_ratings = Rating.where(movie_api_id: movie["id"])
          user_avg = user_ratings.average(:score) || 0
          user_count = user_ratings.count

          total_votes = movie["vote_count"] + user_count

          if total_votes > 0
            combined = ((movie["vote_average"] / 2.0) * movie["vote_count"] + user_avg * user_count) / total_votes
          else
            combined = movie["vote_average"] / 2.0
          end

          movie["user_count"] = user_count
          movie["combined_rating"] = combined.round(2)
      end
      @total_pages = response.parsed_response["total_pages"]
      @current_page = page.to_i
    else
      @movies = []
      @total_pages = 0
      @current_page = 0
    end
  end

  def extract_locale_from_referer
  URI.parse(request.referer || "").query
    &.split("&")
    &.map { |p| p.split("=") }
    &.to_h["locale"]
    &.to_sym
  rescue
    nil
  end

  def cache_movie_data(movie, language)
    CachedMovie.find_or_initialize_by(movie_api_id: movie["id"], language: language).tap do |cached|
    cached.title = movie["title"]
    cached.overview = movie["overview"]
    cached.poster_path = movie["poster_path"]
    cached.tmdb_vote_average = movie["vote_average"]
    cached.tmdb_vote_count = movie["vote_count"]
    cached.updated_at = Time.current
    cached.save!
    end
  end

  def get_cached_movie(movie_api_id, language, popular = false)
  cached = CachedMovie.find_by(movie_api_id: movie_api_id, language: language.to_s)
  return nil if cached.nil?

  if cached.updated_at < 24.hours.ago && popular
    cached.destroy
    return nil
  end
  cached
  end
end
