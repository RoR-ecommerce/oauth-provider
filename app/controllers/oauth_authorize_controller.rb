class OauthAuthorizeController < ApplicationController
  skip_before_filter :verify_authenticity_token

  VALID_GRANT_TYPES = ['password', 'client_credentials']

  def token
    render :text => "Grant type is not valid.", :status => 400 and return unless VALID_GRANT_TYPES.include?(params[:grant_type])
    send "authorize_#{params[:grant_type]}"
  end


  protected

  def authorize_password
    Songkick::OAuth2::Provider.handle_passwords do |client, email, password, scopes|
      if user = User.authenticate?(email, password)
        user.grant_access!(client, :scopes => scopes, :duration => 1.day)
      else
        nil
      end
    end

    oauth = Songkick::OAuth2::Provider.parse(nil, env)
    response.headers = oauth.response_headers

    if body = oauth.response_body
      render :text => body, :status => oauth.response_status
    end
  end

  def authorize_client_credentials
    Songkick::OAuth2::Provider.handle_client_credentials do |client, owner, scopes|
      owner.grant_access!(client, :scopes => scopes, :duration => 1.day)
    end

    oauth = Songkick::OAuth2::Provider.parse(nil, env)
    response.headers = oauth.response_headers

    if body = oauth.response_body
      render :text => body, :status => oauth.response_status
    end
  end

end
