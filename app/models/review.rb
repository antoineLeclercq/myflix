class Review < ActiveRecord::Base
  belongs_to :creator, class_name: 'User', foreign_key: :user_id
  belongs_to :video

  validates :body, presence: true
  validates :rating, presence: true, inclusion: { in: 0..5 }
end
