class RatingsController < ApplicationController
  before_action :require_login # make sure user is logged in

  def create
    rating = Rating.find_or_initialize_by(user_id: current_user.id, movie_api_id: params[:rating][:movie_api_id])
    rating.score = params[:rating][:score]

    if rating.save
      ratings = Rating.where(movie_api_id: rating.movie_api_id).average(:score)
      count = Rating.where(movie_api_id: rating.movie_api_id).count.to_f
      render json: {
        ratings: ratings,
        count: count.to_i
      }
    else
      render json: { errors: rating.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
