module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for user, options = {size: 50}
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def gender_options_for_select
    User.genders.map do |key, _value|
      [t("enums.user.gender.#{key}"), key]
    end
  end

  def can_destroy_user? user
    current_user.admin? && !current_user?(user)
  end
end
