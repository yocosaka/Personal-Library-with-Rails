class Tag < ApplicationRecord
  belongs_to :user
  has_many :image_tags, dependent: :destroy
  has_many :images, through: :image_tags
  validates :name, presence: true

  scope :sort_by_name_asc, -> { order(name: :asc) }
  scope :sort_by_name_desc, -> { order(name: :desc) }
  scope :search_by, ->(keyword) { where('LOWER(name) LIKE ?', "%#{keyword}%") }

  def self.names_downcased
    sort_by_name_asc.map { |tag| tag.name.downcase }
  end

  def images_sort_by(order)
    order == 'asc' ? images.sort_by_name_asc : images.sort_by_name_desc
  end

  def images_search_by(keyword)
    images unless keyword

    images.search_by(keyword) || images
  end

  def self.add_pagenation(param)
    page(param).per(10)
  end

  def self.sort_by_order(order)
    order == 'desc' ? sort_by_name_desc : sort_by_name_asc
  end
end
