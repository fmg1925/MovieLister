class RemoveMovieIdFromRatings < ActiveRecord::Migration[8.0]
  def change
    remove_column :ratings, :movie_id, :integer
  end
end
