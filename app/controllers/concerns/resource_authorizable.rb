module ResourceAuthorizable
  extend ActiveSupport::Concern

  ERROR_MESSAGE = {
    400 => "Bad Request - Parameter missing",
    401 => "Unauthorized - No valid API key provided",
    402 => "Request Failed - Parameters valid but request failed",
    403 => "Forbidden - Access denied",
    404 => "Not Found - The requested item doesn't exist",
    500 => "Server Error = Something went wrong at our end"
  }
 
  module ClassMethods
    def authorize_resource!(*args)
      # Copied from https://github.com/ryanb/cancan/blob/master/lib/cancan/controller_resource.rb
      options = args.extract_options!
      send :before_filter, options.slice(:only, :except, :if, :unless) do |controller|
        controller.send(:authorize_resource, options.except(:only, :except, :if, :unless))
      end
    end
  end

  def authorize_resource(options = {})
    options.reverse_merge!({
      scope: nil
    })
    access_token = oauth2_token(request)
    user = User.find_by_email(params[:email])
    if params[:id]
      user = User.find(params[:id])
    end
    token = Songkick::OAuth2::Provider::AccessToken.new(user,
                              options[:scope],
                              access_token,
                              detect_transport_error(env))
    response.headers = token.response_headers
    render :json => {:message => ERROR_MESSAGE[token.response_status]}, :status => token.response_status unless token.valid?
  end

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
