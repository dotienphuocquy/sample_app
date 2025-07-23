module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for user
    gravatar_id = Digest::MD5::hexdigest user.email.downcase # rubocop:disable Style/ColonMethodCall
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def gender_options_for_select
    User.genders.map do |key, _value|
      [t("enums.user.gender.#{key}"), key]
    end
  end
end
