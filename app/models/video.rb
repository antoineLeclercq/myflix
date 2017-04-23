class Video < ActiveRecord::Base
  include Tokenable

  belongs_to :category
  has_many :reviews, -> { order(created_at: :desc) }

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where(['LOWER(title) LIKE ?', "%#{search_term.downcase}%"]).order(created_at: :desc)
  end

  def average_rating
    return 'No ratings' unless reviews.any?
    (reviews.pluck(:rating).reduce(:+).to_f / reviews.size).round(1)
  end
end
