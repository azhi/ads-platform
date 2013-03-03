FactoryGirl.define do
  sequence(:user_id) { |n| n }
  sequence(:type_id) { |n| n }
  sequence(:ads_id) { |n| n }

  factory :user do
    nickname                      { "user#{generate(:user_id)}" }
    email                         { "user#{generate(:user_id)}@example.com" }
    password                      "foobar12"
    password_confirmation         "foobar12"

    after(:build) { |user| user.skip_confirmation! }
  end

  factory :type do
    name                          { "type#{generate(:type_id)}" }
  end

  factory :advertisement do
    type
    user
    content                       { "advertisement#{generate(:ads_id)}" }
  end

  factory :picture do
    advertisement
    url                           "http://img5.imagebanana.com/img/w8kswt57/SMTH.jpg"
  end
end
