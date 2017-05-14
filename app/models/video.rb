class Video < ActiveRecord::Base
  include Tokenable

  belongs_to :category
  has_many :reviews, -> { order(created_at: :desc) }

  validates :title, presence: true
  validates :description, presence: true

  mount_uploader :small_cover, SmallCoverUploader
  mount_uploader :large_cover, LargeCoverUploader

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where(['LOWER(title) LIKE ?', "%#{search_term.downcase}%"]).order(created_at: :desc)
  end

  def rating
    avg = reviews.average(:rating)
    avg.round(1) if avg
  end
end
