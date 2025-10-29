FactoryBot.define do
  factory :fundraise do
    title { "Test Fundraise" }
    target_cents { 100_000 }
    status { "open" }
  end
end