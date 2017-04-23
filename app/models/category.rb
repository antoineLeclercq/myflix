class Category < ActiveRecord::Base
  include Tokenable

  has_many :videos, -> { order(created_at: :desc) }

  validates :name, presence: true

  def recent_videos
    videos.first(6)
  end
end
