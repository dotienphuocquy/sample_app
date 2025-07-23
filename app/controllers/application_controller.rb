class ApplicationController < ActionController::Base
  before_action :set_locale

  def set_locale
    available = I18n.available_locales.map(&:to_s)
    I18n.locale = if available.include?(params[:locale])
                    params[:locale]
                  else
                    I18n.default_locale
                  end
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
