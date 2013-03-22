class OauthAuthorizeController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def sign_in
    Songkick::OAuth2::Provider.handle_passwords do |client, email, password, scopes|
      if user = User.authenticate?(email, password)
        user.grant_access!(client, :scopes => [], :duration => 1.day)
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
end
