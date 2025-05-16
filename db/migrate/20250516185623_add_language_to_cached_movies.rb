class AddLanguageToCachedMovies < ActiveRecord::Migration[8.0]
  def change
    add_column :cached_movies, :language, :string
  end
end
