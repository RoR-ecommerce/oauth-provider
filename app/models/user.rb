class User < ActiveRecord::Base
  include Songkick::OAuth2::Model::ResourceOwner
  include Songkick::OAuth2::Model::ClientOwner

  has_secure_password

  def self.authenticate?(email, password)
    find_by_email(email).try(:authenticate, password)
  end
end
