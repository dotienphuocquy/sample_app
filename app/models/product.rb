class Product < ApplicationRecord
  validates :name, presence: true

  scope :latest, -> {order(created_at: :desc)}
end
