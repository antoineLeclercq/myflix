class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :user, presence: true
  validates :video, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video
  delegate :name, to: :category, prefix: :category

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating)
    else
      if new_rating.present?
        review = Review.new(rating: new_rating, body: nil, creator: user, video: video)
        review.save(validate: false)
      end
    end
  end

  def review
    @review ||= user.reviews.find_by(video: video)
  end
end
