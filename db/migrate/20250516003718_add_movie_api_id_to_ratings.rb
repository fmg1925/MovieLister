class AddMovieApiIdToRatings < ActiveRecord::Migration[8.0]
  def change
    add_column :ratings, :movie_api_id, :string
  end
end
