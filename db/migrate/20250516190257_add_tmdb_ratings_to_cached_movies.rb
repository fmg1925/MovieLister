class AddTmdbRatingsToCachedMovies < ActiveRecord::Migration[8.0]
  def change
    add_column :cached_movies, :tmdb_vote_average, :float
    add_column :cached_movies, :tmdb_vote_count, :integer
    add_column :cached_movies, :cached_at, :datetime
  end
end
