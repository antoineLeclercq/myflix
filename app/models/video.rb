class Video < ActiveRecord::Base
  include Tokenable
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name "myflix_#{Rails.env}"

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

  def self.search(query, options={})
    search_definition = {
      query: {
        bool: {
          must: {
            multi_match: {
              query: query,
              fields: ['title^100', 'description^50'],
              operator: 'and'
            }
          }
        }
      }
    }

    if query.present? && options[:reviews]
      search_definition[:query][:bool][:must][:multi_match][:fields] << 'reviews.body'
    end

    if options[:rating_from].present? || options[:rating_to].present?
      search_definition[:query][:bool][:filter] = {
        range: {
          rating: {
            gte: (options[:rating_from] if options[:rating_from].present?),
            lte: (options[:rating_to] if options[:rating_to].present?)
          }
        }
      }
    end

    __elasticsearch__.search(search_definition)
  end

  def as_indexed_json(options={})
    as_json(
      methods: [:rating],
      only: [:title, :description],
      include: {
        reviews: { only: [:body] }
      }
    )
  end
end
