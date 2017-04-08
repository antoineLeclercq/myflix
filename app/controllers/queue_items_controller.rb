class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    if current_user.queue_items.include?(queue_item)
      queue_item.destroy
      current_user.normalize_queue_item_positions
    end

    redirect_to my_queue_path
  end

  def update
    begin
      update_queue_items
      current_user.normalize_queue_item_positions
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "Invalid position numbers."
    end

    redirect_to my_queue_path
  end

  private

  def queue_video(video)
    QueueItem.create(video: video, user: current_user, position: current_user.new_queue_item_position) unless current_user.queued_video?(video)
  end

  def update_queue_items
    QueueItem.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data[:id])
        queue_item.update!(position: queue_item_data[:position], rating: queue_item_data[:rating]) if queue_item.user == current_user
      end
    end
  end
end
