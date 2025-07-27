class User < ApplicationRecord
  has_secure_password

  enum gender: {male: 0, female: 1, other: 2}

  USER_PERMIT = %i(name email password
                                password_confirmation
                                birthday gender).freeze

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
  validates :gender, presence: true

  attr_accessor :remember_token, :session_token

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def create_session_token
    self.session_token = User.new_token
    update_column(:session_digest, User.digest(session_token))
  end

  def forget
    update_columns(remember_digest: nil, session_digest: nil)
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost # rubocop:disable Style/HashSyntax
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  def downcase_email
    self.email = email.downcase
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
