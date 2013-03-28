class Api::V1::ApiController < ApplicationController
  include ActionController::MimeResponds
  include ActionController::StrongParameters

  include ResourceAuthorizable

  respond_to :json
end
