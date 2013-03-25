FactoryGirl.define do
  factory :oauth2_client, :class => Songkick::OAuth2::Model::Client do
    name { Faker::Lorem.characters(8) }
    redirect_uri { Faker::Internet.url }
  end
end
