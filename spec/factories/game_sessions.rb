FactoryBot.define do
  factory :game_session do
    association :player
    credits { 10 }
    status { :open }
  end
end
