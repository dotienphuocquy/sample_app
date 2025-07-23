class User < ApplicationRecord
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save :downcase_email

  validates :name, presence: true,
    length: {maximum: Settings.user.max_name_length}
  validates :email, presence: true,
                    length: {maximum: Settings.user.max_email_length},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  validates :birthday, presence: true
  validate :birthday_within_max_age

  private

  def downcase_email
    self.email = email.downcase!
  end

  def birthday_within_max_age
    return if birthday.blank?

    max_age = Settings.user.birthday_year_limit
    max_date = max_age.to_i.years.ago.to_date

    if birthday > Time.zone.today
      errors.add(:birthday, :birthday_in_future)
    elsif birthday < max_date
      errors.add(:birthday, :birthday_too_old, max_age: max_age) # rubocop:disable Style/HashSyntax
    end
  end
end
