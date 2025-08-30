FactoryBot.define do
  factory :player do
    email { Faker::Internet.unique.email }
    account_credits { 0 }
  end
end
