FactoryGirl.define do
  factory :user, :aliases => [:owner] do
    email  { Faker::Internet.email }
    password { Faker::Lorem.characters(8) }
  end

end

