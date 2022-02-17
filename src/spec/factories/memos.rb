FactoryBot.define do
  factory :memo do
    association :favorite
    content { "My Content" }
  end
end
