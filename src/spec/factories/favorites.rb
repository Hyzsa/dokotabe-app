FactoryBot.define do
  factory :favorite do
    association :search_history
    user { search_history.user }
    shop_id { search_history.shop_id }
  end
end
