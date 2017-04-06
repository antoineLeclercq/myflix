class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :user, presence: true
  validates :video, presence: true

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video
  delegate :name, to: :category, prefix: :category

  def rating
    review = user.reviews.find_by(video: video)
    review.rating if review
  end
end
