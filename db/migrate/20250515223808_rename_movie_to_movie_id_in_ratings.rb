class RenameMovieToMovieIdInRatings < ActiveRecord::Migration[8.0]
  def change
    rename_column :ratings, :movie, :movie_id
  end
end
