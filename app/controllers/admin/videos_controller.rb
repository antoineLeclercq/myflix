class Admin::VideosController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "You have successfully added the video '#{@video.title}'."
      redirect_to new_admin_video_path
    else
      flash.now[:error] = 'This video cannot be added, please check the errors.'
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :category_id, :small_cover, :large_cover, :video_url)
  end

  def require_admin
    return if current_user.admin?
    flash[:error] = 'You are not authorized to do that.'
    redirect_to home_path
  end
end
