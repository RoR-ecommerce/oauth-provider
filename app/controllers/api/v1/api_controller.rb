class Api::V1::ApiController < ApplicationController
  include ActionController::MimeResponds
  include ResourceAuthorizable

  respond_to :json

end
