class ApplicationController < ActionController::Base
  before_action :set_locale

  def set_locale
    @params = params[locale: :en]
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale if params[:locale]
  end
end