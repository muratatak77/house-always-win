FactoryBot.define do
  factory :roll do
    association :game_session
    symbols { %w[C C C] }
    win { true }
    reward { 10 }
    cheated { false }
  end
end
