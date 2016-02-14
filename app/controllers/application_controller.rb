class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from 'ActionController::RedirectBackError', with: -> { redirect_to :root }

protected
  def paginate(objs, page = params[:page], per = 10)
    objs.page(page).per(per)
  end

  def find_obj(collection, id)
    collection.find_by(id: id.to_i)
  end

  def respond
    respond_to do |mime|
      mime.html
      mime.json { json_response }
    end
  end

  def respond_with_error(error_msg = 'Object is not existed')
    respond_to do |mime|
      mime.html { redirect_to(:back, alert: error_msg) }
      mime.json { render(json: { error: error_msg }) }
    end
  end

  def json_response(path = nil, **locals)
    render json: {content:
      render_to_string(
        path || "#{params[:controller]}/#{params[:action]}",
        layout: false, formats: [:html], locals: locals
      )
    }
  end
end
