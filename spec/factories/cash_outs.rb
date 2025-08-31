# frozen_string_literal: true

FactoryBot.define do
  factory :cash_out do
    association :player
    association :game_session
    amount { 5 }
  end
end
