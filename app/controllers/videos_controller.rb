class VideosController < ApplicationController
  before_action :require_user

  def index; end

  def show
    @video = VideoDecorator.decorate(Video.find_by(token: params[:id]))
    @review = Review.new
  end

  def search
    @videos = Video.search_by_title(params[:search_term])
  end

  def advanced_search
    if params[:query]
      @videos = Video.search(
        params[:query],
        reviews: (params[:reviews] == 'yes'),
        rating_from: params[:rating_from],
        rating_to: params[:rating_to]
      ).records.to_a
    else
      @videos = []
    end
  end
end
