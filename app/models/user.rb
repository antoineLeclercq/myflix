class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order(:position) }

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
end
