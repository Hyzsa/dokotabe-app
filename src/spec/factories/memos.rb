FactoryBot.define do
  factory :memo do
    association :favorite
    content { "a" * 140 }
  end
end
