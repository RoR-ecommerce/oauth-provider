require 'spec_helper'

describe Api::V1::UsersController do
  let(:user) { create(:user) }
  let(:oauth2_client) { create(:oauth2_client) }

  describe "password grant apis" do
    before :each do
      client = OAuth2::Client.new(oauth2_client.client_id, oauth2_client.client_secret) do |b|
        b.request :url_encoded
        b.adapter :rack, Rails.application
      end
      @token = client.password.get_token(user.email, user.password)
    end

    describe 'User#me' do
      it "returns a user whose username and password was used to get the access token" do
        response = @token.get('/api/v1/me', :params => {:email => user.email})
        response.body.should == user.to_json
      end
    end

    describe 'User#show' do
      it "returns a user whose username and password was used to get the access token" do
        response = @token.get("/api/v1/users/#{user.id}")
        response.body.should == user.to_json
      end
    end
  end

  describe "client grant apis" do
    before :each do
      client = OAuth2::Client.new(oauth2_client.client_id, oauth2_client.client_secret) do |b|
        b.request :url_encoded
        b.adapter :rack, Rails.application
      end
      @token = client.client_credentials.get_token
    end

    describe 'User#create' do
      it "creates a user" do
        email = Faker::Internet.email
        response = @token.post('/api/v1/users', :body => {:user => {:email => email, :password => Faker::Lorem.characters(8) }})
        JSON.parse(response.body)["user"]["email"].should == email
      end
    end


  end
end
