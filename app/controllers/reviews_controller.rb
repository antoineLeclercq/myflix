class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.build(review_params.merge!(creator: current_user))

    if @review.save
      flash[:success] = 'Your review has been added.'
      redirect_to video_path(@video)
    else
      render 'videos/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :body)
  end
end
