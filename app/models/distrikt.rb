class Distrikt < ApplicationRecord
  belongs_to :city
  has_many :users, through: :matches
  belongs_to :score, dependent: :destroy
  has_many :places
end
