require 'spec_helper'

describe OauthAuthorizeController do
  let(:user) { create(:user) }
  let(:oauth2_client) { create(:oauth2_client) }

  describe 'auth ok' do
    it "returns a valid token with valid username and password" do
      client = OAuth2::Client.new(oauth2_client.client_id, oauth2_client.client_secret) do |b|
        b.request :url_encoded
        b.adapter :rack, Rails.application
      end
      token = client.password.get_token(user.email, user.password)
      token.should_not be_expired
    end
  end

  describe 'auth nok' do
    it "return error with invalid username and password" do
      client = OAuth2::Client.new(oauth2_client.client_id, oauth2_client.client_secret) do |b|
        b.request :url_encoded
        b.adapter :rack, Rails.application
      end
      lambda {client.password.get_token(user.email, "123")}.should raise_error(OAuth2::Error)
    end
  end
end
