require 'spec_helper'

describe "OauthAuthorizes" do
  describe "GET /token" do
    it "returns http bad request if grant_type is not valid" do
      get oauth_token_path
      response.status.should be(400)
    end
  end
end
