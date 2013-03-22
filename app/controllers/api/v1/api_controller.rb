class Api::V1::ApiController < ApplicationController
  ERROR_RESPONSE = JSON.unparse('error' => 'Authorization Failed')
  OAUTH_TOKEN            = 'oauth_token'

  def verify_access(scope)
    access_token = oauth2_token(request)
    user  = User.find_by_email(params[:email])
    token = Songkick::OAuth2::Provider::AccessToken.new(user,
                              scope,
                              access_token,
                              detect_transport_error(env))
    response.headers = token.response_headers
    return ERROR_RESPONSE unless token.valid?
    yield user
  end

  protected

  def oauth2_token(request)
    request.params['bearer_token'] || request.params['access_token'] || (request.params["oauth_token"] && !request.params["oauth_signature"] ? request.params["oauth_token"] : nil )  ||
      request.env["HTTP_AUTHORIZATION"] &&
      !request.env["HTTP_AUTHORIZATION"][/(oauth_version="1.0")/] &&
      request.env["HTTP_AUTHORIZATION"][/^(Bearer|OAuth|Token) (token=)?([^\s]*)$/, 3]
  end

  def detect_transport_error(env)
    request = request_from(env)
    if Songkick::OAuth2::Provider.enforce_ssl and not request.ssl?
      Songkick::OAuth2::Provider::Error.new('must make requests using HTTPS')
    elsif request.GET['client_secret']
      Songkick::OAuth2::Provider::Error.new('must not send client credentials in the URI')
    end
  end

  def request_from(env_or_request)
    env = env_or_request.respond_to?(:env) ? env_or_request.env : env_or_request
    env = Rack::MockRequest.env_for(env['REQUEST_URI'] || '', :input => env['RAW_POST_DATA']).merge(env)
    Rack::Request.new(env)
  end


end
