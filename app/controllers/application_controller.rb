class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from 'ActionController::RedirectBackError', with: -> { redirect_to :root }

  def paginate(objs, page = params[:page], per = 10)
    objs.page(page).per(per)
  end
end
