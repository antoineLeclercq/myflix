class Review < ActiveRecord::Base
  belongs_to :creator, class_name: 'User', foreign_key: :user_id
  belongs_to :video, touch: true

  validates :body, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }
end
