require 'spec_helper'

describe User do
  subject { user }
  let(:user) { FactoryGirl.create(:user) }

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe "associations" do
    it { should have_many(:oauth2_clients) }
    it { should have_many(:oauth2_authorizations) }
  end

  describe "columns" do
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:password_digest).of_type(:string) }
  end

  describe "#authenticate?" do
    it "returns true if user and password are valid" do
      User.authenticate?(user.email , user.password)
    end

    it "returns false if user could not be found with email" do
      User.authenticate?(Faker::Internet.email, user.password)
    end

    it "return false if user is found on email but password does not match" do
      User.authenticate?(user.email, Faker::Lorem.characters(8))
    end
  end

end
