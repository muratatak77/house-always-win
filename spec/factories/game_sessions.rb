# frozen_string_literal: true

FactoryBot.define do
  factory :game_session do
    association :player
    credits { 10 }
    status { :open }
  end
end
