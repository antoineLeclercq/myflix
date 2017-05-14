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
end
