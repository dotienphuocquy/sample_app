class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end

  scope :recent_posts, -> {order(created_at: :desc)}

  validates :content, presence: true, length: {maximum: 140}
  validates :image,
            content_type: {in: %w(image/jpeg image/gif image/png),
                           message: I18n.t("must_be_a_valid_image_format")},
                           size: {less_than: 5.megabytes,
                                  message: I18n.t("must_be_less_than_5MB")}
end
