class Distrikt < ApplicationRecord
  belongs_to :city
  has_many :matches
  has_many :users, through: :matches
  belongs_to :score, dependent: :destroy
  has_many :places
  has_attachments :photos, maximum: 6
  max_paginates_per 50

  acts_as_favoritable

  geocoded_by :address
  after_validation :geocode

  scope :wishlist, -> { where(favorited: "nightlife")}
  scope :visited, -> { where(category: "restaurant")}
end
