class Video < ActiveRecord::Base
  belongs_to :category

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where(['LOWER(title) LIKE ?', "%#{search_term.downcase}%"]).order(created_at: :desc)
  end
end
