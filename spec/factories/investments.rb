FactoryBot.define do
  factory :investment do
    association :user
    association :fundraise
    amount_cents { 10_000 }
  end
end