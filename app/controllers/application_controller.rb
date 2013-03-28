class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  #rescue_from Exception, :with => :render_500

  def render_500
    error = { :message => "Server error - Something went wrong at our end"}
    render :json => error, :status => 500
  end

  def render_404
    error = { :message => "Not Found - The requested route or item doesn't exist"}
    render :json => error, :status => 404
  end

end
