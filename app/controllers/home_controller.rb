class HomeController < ApplicationController
  def index
    return unless logged_in?

    user_ratings = current_user.ratings.order(created_at: :asc)
    language = I18n.locale == :es ? "es-MX" : "en-US"

    @rated_movies = user_ratings.map do |rating|
      movie_id = rating.movie_api_id

      cached = CachedMovie.find_by(movie_api_id: movie_id, language: language)
      next unless cached
      tmdb_rating_5 = cached.tmdb_vote_average.to_f / 2.0
      tmdb_votes = cached.tmdb_vote_count.to_i rescue 0

      user_avg = Rating.where(movie_api_id: movie_id).average(:score) || 0
      user_count = Rating.where(movie_api_id: movie_id).count
      total_votes = tmdb_votes + user_count

      combined = total_votes > 0 ? ((tmdb_rating_5 * tmdb_votes + user_avg * user_count) / total_votes) : tmdb_rating_5

      {
        "id" => movie_id,
        "title" => cached.title,
        "overview" => cached.overview,
        "poster_path" => cached.poster_path,
        "user_score" => rating.score,
        "combined_rating" => combined.round(2),
        "user_count" => total_votes
      }
    end.compact
  end
end
