class User < ActiveRecord::Base
  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queue_items, -> { order(:position) }

  has_many :following_relationships, class_name: 'Relationship', foreign_key: :follower_id
  has_many :leaders, through: :following_relationships

  has_many :leading_relationships, class_name: 'Relationship', foreign_key: :leader_id
  has_many :followers, through: :leading_relationships

  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 5 }
  validates :full_name, presence: true

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index + 1)
    end
  end

  def new_queue_item_position
    queue_items.count + 1
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end

  def can_follow?(another_user)
    !(follows?(another_user) || self == another_user)
  end
end
