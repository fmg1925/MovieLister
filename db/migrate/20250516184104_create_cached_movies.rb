class CreateCachedMovies < ActiveRecord::Migration[8.0]
  def change
    create_table :cached_movies do |t|
      t.integer :movie_api_id
      t.string :title
      t.text :overview
      t.string :poster_path

      t.timestamps
    end
  end
end
